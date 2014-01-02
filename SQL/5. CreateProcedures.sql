CREATE OR REPLACE FUNCTION usp_TierArztBesuche(_id integer) 
	RETURNS TABLE(PK_Tier integer, Geburtsdatum date, Gewicht double precision, "Alter" interval, Datum date, Diagnose text, Medikamente text ) AS $func$
DECLARE

BEGIN

RETURN QUERY EXECUTE 
	'
	SELECT  
		TIER.PK_Tier,
		TIER.Geburtsdatum,
		TIER.Gewicht,
		(now() - TIER.Anschaffungs_Datum) AS Alter,
		TIERARZTBESUCH.Datum,
		TIERARZTBESUCH.Diagnose,
		TIERARZTBESUCH.Medikamente
	FROM 
		TIERARZTBESUCH
	JOIN 
		TIER
	ON
		TIERARZTBESUCH.FK_Tier = TIER.PK_Tier
	WHERE	
		TIER.PK_Tier = $1'
USING _id;

END
$func$ LANGUAGE plpgsql;

--SELECT * FROM usp_TierArztBesuche(2002);