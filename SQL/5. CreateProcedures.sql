CREATE OR REPLACE FUNCTION usp_TierArztBesuche(_id integer) 
	RETURNS TABLE(
		PK_Tier integer, 
		Geburtsdatum date, 
		Gewicht double precision, 
		"Alter" interval, 
		Datum date, 
		Diagnose text, 
		Medikamente text ) 
	AS $func$
DECLARE

BEGIN

RETURN QUERY 
	SELECT  
		TIER.PK_Tier,
		TIER.Geburtsdatum,
		TIER.Gewicht,
		(now() - TIER.Anschaffungsdatum) AS Alter,
		TIERARZTBESUCH.Datum,
		TIERARZTBESUCH.Diagnose,
		TIERARZTBESUCH.Medikamente
	FROM 
		public.TIERARZTBESUCH
	JOIN 
		public.TIER
	ON
		TIERARZTBESUCH.FK_Tier = TIER.PK_Tier
	WHERE	
		TIER.PK_Tier = _id;
END
$func$ LANGUAGE plpgsql;

COMMENT ON 
	FUNCTION usp_TierArztBesuche(_id integer) 
	IS 'Zeigt alle Tierarztbesuche des Tieres anhand des Primary Keys an';
--SELECT * FROM usp_TierArztBesuche(1023);

CREATE OR REPLACE FUNCTION usp_AngestellterStallarbeiten(_id integer, _start date, _end Date) 
	RETURNS TABLE(
		PK_Angestellter integer,
		Vorname text,
		Nachname text,
		FK_Stall integer,
		VerrichteteArbeit text,
		Datum date,
		Dauer interval
	)
	AS $func$
declare

BEGIN

RETURN QUERY
	select
		ANGESTELLTER.PK_Angestellter,
		ANGESTELLTER.Vorname,
		ANGESTELLTER.Nachname,
		ANGESTELLTER_STALLARBEITEN.FK_Stall,
		ANGESTELLTER_STALLARBEITEN.VerrichteteArbeit,
		ANGESTELLTER_STALLARBEITEN.Datum,
		ANGESTELLTER_STALLARBEITEN.Dauer
	FROM
		public.ANGESTELLTER
	JOIN
		public.ANGESTELLTER_STALLARBEITEN
	ON
		ANGESTELLTER_STALLARBEITEN.FK_Angestellter = ANGESTELLTER.PK_Angestellter
	WHERE
		ANGESTELLTER.PK_Angestellter = _id AND
		ANGESTELLTER_STALLARBEITEN.Datum BETWEEN _start and _end;
end
$func$ language plpgsql;

COMMENT ON 
	FUNCTION usp_AngestellterStallarbeiten(_id integer, _start date, _end Date) 
	IS 'Gibt alle Verrichteten Arbeiten eines Angestellten innerhalb des angegebenen Zeitraums aus';
--SELECT * FROM usp_AngestellterStallarbeiten(2, '1961-06-16', now()::date);

CREATE OR REPLACE FUNCTION usp_MaschineVerwendung(_id integer, _start date, _end Date)
	RETURNS TABLE(
		PK_Angestellter integer,
		Vorname text,
		Nachname text,
		FK_Maschine integer,
		Datum date,
		Dauer interval,
		Typ text,
		name text
	)
	AS $func$
declare

BEGIN

RETURN QUERY
	SELECT
		ANGESTELLTER.PK_Angestellter,
		ANGESTELLTER.Vorname,
		ANGESTELLTER.Nachname,
		MASCHINE_VERWENDUNG.FK_Maschine,
		MASCHINE_VERWENDUNG.Verwendungsdatum,
		MASCHINE_VERWENDUNG.Dauer,
		MASCHINE.Typ,
		MASCHINE.Name
	FROM
		public.ANGESTELLTER
	JOIN
		public.MASCHINE_VERWENDUNG
	ON
		MASCHINE_VERWENDUNG.FK_Angestellter = ANGESTELLTER.PK_Angestellter
	JOIN
		public.MASCHINE
	ON
		MASCHINE_VERWENDUNG.FK_Maschine = MASCHINE.PK_Maschine
	WHERE
		ANGESTELLTER.PK_Angestellter = _id AND
		MASCHINE_VERWENDUNG.Verwendungsdatum BETWEEN _start and _end;
end
$func$ language plpgsql;

COMMENT ON
	FUNCTION usp_MaschineVerwendung(_id integer, _start date, _end Date)
	IS 'Gibt alle Verwendeten Maschinen eines Angestellten innerhalb des angegebenen Zeitraums aus';
--SELECT * FROM usp_MaschineVerwendung(2, '1961-06-16', now()::date);

CREATE OR REPLACE FUNCTION 
	usp_TierHinzufuegen(
		_Stallid integer, 
		_Tiername text,
		_Geburtsdatum date,
		_Anschaffungsdatum date,
		_Gewicht double precision,
		_Tierart text,
		_Futterid integer,
		_Futtermenge double precision,
		_Datum date DEFAULT now()
	)
	RETURNS BOOLEAN
	AS $$
DECLARE
	 _Tiermenge integer = (SELECT count(*) FROM TIER WHERE FK_STALL = _Stallid);
	 _Stallgroesse integer = (SELECT Kapazitaet FROM STALL WHERE PK_Stall = _Stallid);
BEGIN
	IF(_Stallgroesse > _Tiermenge) THEN	
		INSERT INTO 
			public.TIER(
				FK_Stall, 
				Name, 
				Geburtsdatum, 
				Anschaffungsdatum, 
				Gewicht
			) 
		VALUES
			(
				_Stallid,
				_Tiername,
				_Geburtsdatum,
				_Anschaffungsdatum,
				_Gewicht
			);
			
		INSERT INTO
			public.TIER_ATTRIBUTE
		VALUES
			(
				currval('tier_pk_tier_seq'),
				(
					SELECT 
						PK_Attribute
					FROM
						public.Attribute
					WHERE
						Name = 'Tierart' AND 
						Wert = _Tierart
				)
			);

		INSERT INTO 
			public.FUTTERMENGE_PRO_TIER
		VALUES
			(
				currval('tier_pk_tier_seq'),
				_Futterid,
				_Futtermenge,
				_Datum
			);
		RETURN True;
	ELSE
		RAISE EXCEPTION 'stall_exception'
			USING HINT = 'Stall ist zu klein';
	END IF;
	
EXCEPTION
	WHEN not_null_violation THEN
		RAISE NOTICE 'Tierart existiert nicht';
		return False;
END
$$ LANGUAGE plpgsql;

COMMENT ON
	FUNCTION usp_TierHinzufuegen(
		_Stallid integer, 
		_Tiername text, 
		_Geburtsdatum date, 
		_Anschaffungsdatum date, 
		_Gewicht double precision, 
		_Tierart text, 
		_Futterid integer, 
		_Futtermenge double precision, 
		_Datum date)
	IS 'Ein neues Tier eintragen, Tierart muss existieren';

--SELECT usp_TierHinzufuegen(4, 'bess', '1999-06-16', '1999-08-23', 250, 'Hausrind', 4, 3);

CREATE OR REPLACE FUNCTION
	usp_DeleteTier(_id integer)
	RETURNS VOID
	AS $$
DECLARE

BEGIN
	DELETE FROM TIER_ATTRIBUTE WHERE FK_TIER = _id;
	DELETE FROM TIERARZTBESUCH WHERE FK_TIER = _id;
	DELETE FROM FUTTERMENGE_PRO_TIER WHERE FK_TIER = _id;
	DELETE FROM TIER WHERE PK_Tier = _id;
END
$$ LANGUAGE plpgsql;

COMMENT ON 
	FUNCTION usp_DeleteTier(_id integer)
	IS 'Ein Tier aus der Datenbank löschen.';
	

CREATE OR REPLACE FUNCTION
	usp_AckerDaten(_id integer, _start date, _end Date)
	RETURNS TABLE(
		PK_Acker integer,
		Standort text,
		Groesse integer,
		Datum Date,
		Messwert double precision,
		Saatgut_Name text,
		Duenger_Name text
	)
	AS $func$

DECLARE

BEGIN

RETURN QUERY
	SELECT
		ACKER.PK_Acker,
		ACKER.Standort,
		ACKER.Groesse,
		ACKERDATEN.Datum,
		ACKERDATEN.Messwert,
		SAATGUT.Name,
		DUENGER.Name
	FROM
		ACKER
	JOIN
		ACKERDATEN
	ON
		ACKER.PK_Acker = ACKERDATEN.FK_Acker
	JOIN
		SAATGUT
	ON
		ACKERDATEN.FK_Saatgut = SAATGUT.PK_Saatgut
	JOIN
		DUENGER
	ON
		ACKERDATEN.FK_Duenger = DUENGER.PK_Duenger
	WHERE
		ACKER.PK_Acker = _id AND
		ACKERDATEN.Datum BETWEEN _start AND _end;
END
$func$ LANGUAGE plpgsql;

COMMENT ON 
	FUNCTION usp_AckerDaten (_id integer, _start date, _end date)
	IS 'Gibt alle Daten eines Ackers innerhalb des angegebenen Zeitraums aus.';

-- SELECT * FROM usp_AckerDaten(2,'1961-06-11','1962-07-26');

CREATE OR REPLACE FUNCTION usp_UpdateTierStall(_stallart text, _tier int)
	RETURNS BOOLEAN AS $$
DECLARE
	_stall integer := (SELECT usp_KonvertiereStall(_stallart));
	_capacity integer := (SELECT Kapazitaet FROM STALL WHERE Pk_Stall = _stall);
	_animals integer := (SELECT COUNT(*) FROM TIER WHERE Fk_Stall = _stall GROUP BY Fk_Stall);
BEGIN
		IF (_capacity - _animals) >= 1 THEN
			UPDATE TIER SET Fk_Stall = _stall WHERE Pk_Tier = _tier;
			RETURN TRUE;
		END IF;
		RETURN FALSE;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_TierAttribute(_tier int)
	RETURNS TABLE (
		Pk_Attribute integer,
		Name text,
		Wert text
	) AS $$
DECLARE
BEGIN
	RETURN QUERY
		SELECT
			ATTRIBUTE.Pk_Attribute AS Pk_Attribute,
			ATTRIBUTE.Name AS Name,
			ATTRIBUTE.Wert AS Wert
		FROM
			ATTRIBUTE
		JOIN 
			TIER_ATTRIBUTE
		ON 
			ATTRIBUTE.Pk_Attribute = TIER_ATTRIBUTE.Fk_Attribute
		JOIN 
			TIER
		ON 
			TIER_ATTRIBUTE.Fk_Tier = TIER.Pk_Tier
		WHERE
			TIER.Pk_Tier = _tier;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION 
	usp_UpdateTierFutter(
		_id integer, 
		_futterid integer, 
		_menge double precision, 
		_date date = now()
	)
	RETURNS VOID
	AS $$

DECLARE

BEGIN
	INSERT INTO FUTTERMENGE_PRO_TIER VALUES(_id, _futterid, _menge, _date);
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_TierFutter(_tier integer)
	RETURNS TABLE (
		Pk_Futter integer,
		FutterMenge double precision
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		Fk_Futter, Menge
	FROM
		FUTTERMENGE_PRO_TIER
	WHERE
		Fk_Tier = _tier;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_TiereImStall(_stall integer)
	RETURNS TABLE (
		Pk_Tier integer,
		Name text,
		Geburtsdatum date,
		Anschaffungsdatum date,
		Gewicht double precision,
		Tierart text
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		TIER.Pk_Tier, TIER.Name, TIER.Geburtsdatum, TIER.Anschaffungsdatum, TIER.Gewicht, ATTRIBUTE.Wert
	FROM
		STALL
	JOIN
		TIER
	ON
		STALL.Pk_Stall = TIER.Fk_Stall
	JOIN
		TIER_ATTRIBUTE
	ON
		TIER.Pk_Tier = TIER_ATTRIBUTE.Fk_Tier
	JOIN
		ATTRIBUTE
	ON
		TIER_ATTRIBUTE.Fk_Attribute = ATTRIBUTE.Pk_Attribute
	WHERE
		STALL.Pk_Stall = _stall
	AND
		ATTRIBUTE.Name = 'Tierart';
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_Stallarbeiten(_stall integer) 
	RETURNS TABLE(
		PK_Angestellter integer,
		Vorname text,
		Nachname text,
		FK_Stall integer,
		VerrichteteArbeit text,
		Datum date,
		Dauer interval
	)
	AS $func$
declare

BEGIN

	RETURN
		QUERY
	SELECT
		ANGESTELLTER.PK_Angestellter,
		ANGESTELLTER.Vorname,
		ANGESTELLTER.Nachname,
		ANGESTELLTER_STALLARBEITEN.FK_Stall,
		ANGESTELLTER_STALLARBEITEN.VerrichteteArbeit,
		ANGESTELLTER_STALLARBEITEN.Datum,
		ANGESTELLTER_STALLARBEITEN.Dauer
	FROM
		ANGESTELLTER
	JOIN
		ANGESTELLTER_STALLARBEITEN
	ON
		ANGESTELLTER_STALLARBEITEN.Fk_Angestellter = ANGESTELLTER.Pk_Angestellter
	JOIN
		STALL
	ON
		STALL.Pk_Stall = ANGESTELLTER_STALLARBEITEN.Fk_Stall
	WHERE
		STALL.Pk_Stall = _stall;
end
$func$ language plpgsql;

CREATE OR REPLACE FUNCTION usp_Restkapazitaet(_lager integer)
	RETURNS bigint AS $$
DECLARE
	_capacity bigint := (SELECT Kapazitaet FROM LAGER WHERE Pk_Lager = _lager);
	_futter bigint := 0;
	_saatgut bigint := 0;
	_duenger bigint := 0;
	_result bigint := 0;
BEGIN
	-- futter
	SELECT
		COALESCE(SUM(FUTTER_BESTAND.Bestand), 0)
	INTO
		_futter
	FROM
		LAGER
	LEFT JOIN
		FUTTER_BESTAND
	ON
		LAGER.Pk_Lager = FUTTER_BESTAND.Fk_Lager
	WHERE
		LAGER.Pk_Lager = _lager
	GROUP BY
		LAGER.Pk_Lager;
	-- duenger	
	SELECT
		COALESCE(SUM(DUENGER_BESTAND.Bestand), 0)
	INTO
		_duenger
	FROM
		LAGER
	LEFT JOIN
		DUENGER_BESTAND
	ON
		LAGER.Pk_Lager = DUENGER_BESTAND.Fk_Lager
	WHERE
		LAGER.Pk_Lager = _lager
	GROUP BY
		LAGER.Pk_Lager;
	-- saatgut
	SELECT
		COALESCE(SUM(SAATGUT_BESTAND.Bestand), 0)
	INTO
		_saatgut
	FROM
		LAGER
	LEFT JOIN
		SAATGUT_BESTAND
	ON
		LAGER.Pk_Lager = SAATGUT_BESTAND.Fk_Lager
	WHERE
		LAGER.Pk_Lager = _lager
	GROUP BY
		LAGER.Pk_Lager;
	-- result
	_result := _capacity - (_futter + _duenger + _saatgut);
	-- return
	RETURN _result;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_FutterBestand(_futter integer)
	RETURNS TABLE (
		Pk_Lager integer,
		Lagerart text,
		Kapazitaet integer,
		Bestand integer,
		Restkapazitaet bigint
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT 
		A.Lager,
		A.Lagerart, 
		A.Kapazitaet, 
		A.Bestand,
		A.Restkapazitaet
	FROM
	(
		SELECT
			LAGER.Pk_Lager AS Lager,
			LAGER.Lagerart AS Lagerart,
			LAGER.Kapazitaet AS Kapazitaet,
			FUTTER_BESTAND.Bestand AS Bestand,
			usp_Restkapazitaet(LAGER.Pk_Lager) AS Restkapazitaet
		FROM
			LAGER
		JOIN
			FUTTER_BESTAND
		ON
			LAGER.Pk_Lager = FUTTER_BESTAND.Fk_Lager
		JOIN
			FUTTER
		ON
			FUTTER_BESTAND.Fk_Futter = FUTTER.Pk_Futter
		WHERE
			FUTTER_BESTAND.Fk_Futter = _futter AND LAGER.Pk_Lager = FUTTER_BESTAND.Fk_Lager
	) A;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_MaschineChronik(_maschine integer)
	RETURNS TABLE (
		Pk_Angestellter integer,
		Vorname text,
		Nachname text,
		Verwendungsdatum date,
		Verwendungsdauer interval
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		ANGESTELLTER.Pk_Angestellter,
		ANGESTELLTER.Vorname,
		ANGESTELLTER.Nachname,
		MASCHINE_VERWENDUNG.Verwendungsdatum,
		MASCHINE_VERWENDUNG.Dauer
	FROM
		ANGESTELLTER
	JOIN
		MASCHINE_VERWENDUNG
	ON
		ANGESTELLTER.Pk_Angestellter = MASCHINE_VERWENDUNG.Fk_Angestellter
	JOIN
		MASCHINE
	ON
		MASCHINE_VERWENDUNG.Fk_Maschine = MASCHINE.Pk_Maschine
	WHERE
		MASCHINE.Pk_Maschine = _maschine;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_DuengerBestand(_lager integer)
	RETURNS TABLE (
		Pk_Duenger integer,
		Name text,
		Preis double precision,
		Bestand integer,
		Restkapazitaet bigint
	) AS $$
DECLARE
	_capacity bigint := (SELECT usp_Restkapazitaet(_lager));
BEGIN
	RETURN
		QUERY
	SELECT 
		DUENGER.Pk_Duenger,
		DUENGER.Name, 
		DUENGER.Preis, 
		DUENGER_BESTAND.Bestand,
		_capacity
	FROM
		LAGER
	JOIN
		DUENGER_BESTAND
	ON
		LAGER.Pk_Lager = DUENGER_BESTAND.Fk_Lager
	JOIN
		DUENGER
	ON
		DUENGER_BESTAND.Fk_Duenger = DUENGER.Pk_Duenger
	WHERE
		DUENGER_BESTAND.Fk_Lager = _lager;
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION usp_FutterLagerBestand(_lager integer)
	RETURNS TABLE (
		Pk_Futter integer,
		Name text,
		Preis double precision,
		Bestand integer,
		Restkapazitaet bigint
	) AS $$
DECLARE
	_capacity bigint := (SELECT usp_Restkapazitaet(_lager));
BEGIN
	RETURN
		QUERY
	SELECT 
		FUTTER.Pk_Futter,
		FUTTER.Name, 
		FUTTER.Preis, 
		FUTTER_BESTAND.Bestand,
		_capacity
	FROM
		LAGER
	JOIN
		FUTTER_BESTAND
	ON
		LAGER.Pk_Lager = FUTTER_BESTAND.Fk_Lager
	JOIN
		FUTTER
	ON
		FUTTER_BESTAND.Fk_Futter = FUTTER.Pk_Futter
	WHERE
		FUTTER_BESTAND.Fk_Lager = _lager;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_LagerMaschine(_lager integer)
	RETURNS TABLE (
		Pk_Maschine integer,
		Typ text,
		Name text,
		Kosten double precision,
		Anschaffungsdatum date,
		Abschreibungsdatum date
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		MASCHINE.Pk_Maschine,
		MASCHINE.Typ,
		MASCHINE.Name,
		MASCHINE.Kosten,
		MASCHINE.Anschaffungsdatum,
		MASCHINE.Abschreibungsdatum
	FROM
		MASCHINE
	WHERE
		Fk_Lager = _lager;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_SaatgutBestand(_lager integer)
	RETURNS TABLE (
		Pk_Saatgut integer,
		Name text,
		Preis double precision,
		Bestand integer,
		Restkapazitaet bigint
	) AS $$
DECLARE
	_capacity bigint := (SELECT usp_Restkapazitaet(_lager));
BEGIN
	RETURN
		QUERY
	SELECT 
		SAATGUT.Pk_Saatgut,
		SAATGUT.Name, 
		SAATGUT.Preis, 
		SAATGUT_BESTAND.Bestand,
		_capacity
	FROM
		LAGER
	JOIN
		SAATGUT_BESTAND
	ON
		LAGER.Pk_Lager = SAATGUT_BESTAND.Fk_Lager
	JOIN
		SAATGUT
	ON
		SAATGUT_BESTAND.Fk_Saatgut = SAATGUT.Pk_Saatgut
	WHERE
		SAATGUT_BESTAND.Fk_Lager = _lager;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_AckerDaten(_acker integer)
	RETURNS TABLE (
		Duenger text,
		Saatgut text,
		Datum date,
		Messwert double precision
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		DUENGER.Name, SAATGUT.Name, ACKERDATEN.Datum, ACKERDATEN.Messwert
	FROM
		ACKERDATEN
	JOIN
		DUENGER
	ON
		ACKERDATEN.Fk_Duenger = DUENGER.Pk_Duenger
	JOIN
		SAATGUT
	ON
		ACKERDATEN.Fk_Saatgut = SAATGUT.Pk_Saatgut
	WHERE
		ACKERDATEN.Fk_Acker = _acker;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_DuengerLagerBestand(_duenger integer)
	RETURNS TABLE (
		PK_Lager integer,
		Lagerart text,
		Kapazitaet integer,
		Bestand integer,
		Restkapazitaet bigint
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		LAGER.PK_Lager, 
		LAGER.Lagerart, 
		LAGER.Kapazitaet, 
		DUENGER_BESTAND.Bestand,
		(SELECT usp_Restkapazitaet(LAGER.Pk_Lager))
	FROM
		LAGER
	JOIN
		DUENGER_BESTAND
	ON
		LAGER.Pk_Lager = DUENGER_BESTAND.Fk_Lager
	WHERE
		DUENGER_BESTAND.Fk_Duenger = _duenger;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_SaatgutLagerBestand(_saatgut integer)
	RETURNS TABLE (
		PK_Lager integer,
		Lagerart text,
		Kapazitaet integer,
		Bestand integer,
		Restkapazitaet bigint
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		LAGER.PK_Lager, 
		LAGER.Lagerart, 
		LAGER.Kapazitaet, 
		SAATGUT_BESTAND.Bestand,
		(SELECT usp_Restkapazitaet(LAGER.Pk_Lager))
	FROM
		LAGER
	JOIN
		SAATGUT_BESTAND
	ON
		LAGER.Pk_Lager = SAATGUT_BESTAND.Fk_Lager
	WHERE
		SAATGUT_BESTAND.Fk_Saatgut = _saatgut;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_AngestellterArbeiten(_angestellter integer)
	RETURNS TABLE (
		Pk_Stall integer,
		Stallart text,
		Arbeit text,
		Datum date,
		Dauer interval
	) AS $$
DECLARE
BEGIN
	RETURN
		QUERY
	SELECT
		STALL.Pk_Stall,
		STALL.Stallart,
		ANGESTELLTER_STALLARBEITEN.Verrichtetearbeit,
		ANGESTELLTER_STALLARBEITEN.Datum,
		ANGESTELLTER_STALLARBEITEN.Dauer
	FROM
		STALL
	JOIN
		ANGESTELLTER_STALLARBEITEN
	ON
		STALL.Pk_Stall = ANGESTELLTER_STALLARBEITEN.Fk_Stall
	WHERE
		ANGESTELLTER_STALLARBEITEN.Fk_Angestellter = _angestellter;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_KonvertiereStall(_stallart text)
	RETURNS integer AS $$
DECLARE
	_result integer := (SELECT Pk_Stall FROM STALL WHERE Stallart = _stallart);
BEGIN
	RETURN _result;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usp_GetAttribut(_Name text)
	RETURNS TABLE(Wert text)
	AS $$
DECLARE
BEGIN
	RETURN QUERY
		SELECT
			ATTRIBUTE.Wert
		FROM
			ATTRIBUTE
		WHERE
			ATTRIBUTE.Name = _Name;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION 
	usp_StallEinfuegen(
		_Stallart text,
		_Kapazitaet text, 
		_Standort text
	)
	RETURNS VOID
	AS $$
DECLARE

BEGIN
	INSERT INTO
		public.STALL(
			Stallart,
			Kapazitaet,
			Standort
		)
	VALUES
		(
			_Stallart,
			_Kapazitaet,
			_Standort
		);
			
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
	usp_DeleteStall(_id integer, _NUKE boolean)
	RETURNS VOID
	AS $$
DECLARE
	I integer;
BEGIN
	if(_NUKE) THEN
		FOR I IN SELECT PK_Tier FROM TIER WHERE FK_Stall = _id LOOP
			PERFORM usp_DeleteTier(I);
		END LOOP;
		DELETE FROM ANGESTELLTER_STALLARBEITEN WHERE FK_Stall = _id;
	END IF;

	DELETE FROM STALL WHERE PK_STALL = _id;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
	usp_FutterEinfuegen(_Name text, _Preis float, _Bestand integer,_Lager integer)
	RETURNS VOID
	AS $$
DECLARE
BEGIN
	INSERT INTO FUTTER(Name, Preis) VALUES(_Name, _Preis);
	INSERT INTO FUTTER_BESTAND VALUES(currval('futter_pk_futter_seq'), _Lager, _Bestand);
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
	usp_DeleteFutter(_id integer, _NUKE boolean)
	RETURNS VOID
	AS $$
DECLARE

BEGIN
	IF (_NUKE) THEN
		DELETE FROM FUTTER_BESTAND WHERE FK_Futter = _id;
		DELETE FROM FUTTERMENGE_PRO_TIER WHERE FK_Futter = _id;
		DELETE FROM FUTTER WHERE PK_Futter = _id;
	END IF;
	DELETE FROM FUTTER WHERE PK_Futter = _id;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
	usp_MaschineEinfuegen(
		_Lager integer,
		_Preis double precision,
		_Typ text,
		_Name text,
		_Anschaffungsdatum date,
		_Abschreibungsdatum date
	)
	RETURNS VOID
	AS $$
DECLARE

BEGIN
	INSERT INTO MASCHINE(FK_Lager, Kosten, Anschaffungsdatum, Abschreibungsdatum, Typ, Name) 
		VALUES (_Lager, _Preis,  _Anschaffungsdatum::date, _Abschreibungsdatum::date, _Typ, _Name);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
	usp_DeleteMaschine(_id integer, _NUKE boolean)
	RETURNS VOID
	AS $$
DECLARE

BEGIN
	IF(_NUKE) THEN
		DELETE FROM MASCHINE_VERWENDUNG WHERE FK_Maschine = _id;
	END IF;
	DELETE FROM MASCHINE WHERE PK_Maschine = _id;
END
$$ LANGUAGE plpgsql;
