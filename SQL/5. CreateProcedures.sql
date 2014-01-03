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

--SELECT * FROM usp_TierArztBesuche(1023);

CREATE OR REPLACE FUNCTION usp_AngestellterStallarbeiten(_id integer) 
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
		ANGESTELLTER.PK_Angestellter = _id;
end
$func$ language plpgsql;

--SELECT * FROM usp_AngestellterStallarbeiten(1);