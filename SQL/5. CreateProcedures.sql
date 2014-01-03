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