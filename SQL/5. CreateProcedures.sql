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
		_Tierart text
		
	)
	RETURNS BOOLEAN
	AS $$
DECLARE

BEGIN
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
	RETURN True;
	
EXCEPTION
	WHEN not_null_violation THEN
		RAISE NOTICE 'Tierart existiert nicht';
		return False;	
END
$$ LANGUAGE plpgsql;

COMMENT ON
	FUNCTION usp_TierHinzufuegen(_Stallid integer, _Tiername text, _Geburtsdatum date, _Anschaffungs_Datum date, _Gewicht double precision, _Tierart text)
	IS 'Ein neues Tier eintragen, Tierart muss existieren';

--SELECT usp_TierHinzufuegen(1,'bess', '1999-06-16', '1999-08-23', 250, 'Hausrsind'); -- exception test