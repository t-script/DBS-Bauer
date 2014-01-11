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
		(now() - TIER.Anschaffungs_Datum) AS Alter,
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
		_Anschaffungs_Datum date,
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
	 _Stallgroesse integer = (SELECT Kapazitaet FROM STALL WHERE PK_STALL = _Stallid);
BEGIN
	IF(_Stallgroesse > _Tiermenge) THEN	
		INSERT INTO 
			public.TIER(
				FK_Stall, 
				Name, 
				Geburtsdatum, 
				Anschaffungs_Datum, 
				Gewicht
			) 
		VALUES
			(
				_Stallid,
				_Tiername,
				_Geburtsdatum,
				_Anschaffungs_Datum,
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
		_Anschaffungs_Datum date, 
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
	DELETE FROM FUTTERMENGE_PRO_TIER WHERE FK_TIER = _id;
	DELETE FROM TIER WHERE PK_TIER = _id;
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

CREATE OR REPLACE FUNCTION usp_UpdateTierStall(_stall int, _tier int)
	RETURNS BOOLEAN AS $$
DECLARE
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

