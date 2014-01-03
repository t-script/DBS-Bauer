CREATE OR REPLACE VIEW "v_Schweine" AS
	SELECT 
		TIER.PK_Tier,
		TIER.Name, 
		TIER.Geburtsdatum, 
		TIER.Anschaffungs_Datum, 
		TIER.Gewicht, 
		(ATTRIBUTE.Wert) AS TIERART
	FROM 
		public.TIER, 
		public.TIER_ATTRIBUTE, 
		public.ATTRIBUTE
	WHERE 
		TIER.PK_Tier = TIER_ATTRIBUTE.FK_Tier AND
		TIER_ATTRIBUTE.FK_Attribute = ATTRIBUTE.PK_Attribute AND
		ATTRIBUTE.Wert = 'Hausschwein';

CREATE OR REPLACE VIEW "v_Kuehe" AS
	SELECT 
		TIER.PK_Tier,
		TIER.Name, 
		TIER.Geburtsdatum, 
		TIER.Anschaffungs_Datum, 
		TIER.Gewicht, 
		(ATTRIBUTE.Wert) AS TIERART
	FROM 
		public.TIER, 
		public.TIER_ATTRIBUTE, 
		public.ATTRIBUTE
	WHERE 
		TIER.PK_Tier = TIER_ATTRIBUTE.FK_Tier AND
		TIER_ATTRIBUTE.FK_Attribute = ATTRIBUTE.PK_Attribute AND
		ATTRIBUTE.Wert = 'Hausrind';

CREATE OR REPLACE VIEW "v_Huehner" AS
	SELECT 
		TIER.PK_Tier,
		TIER.Name, 
		TIER.Geburtsdatum, 
		TIER.Anschaffungs_Datum, 
		TIER.Gewicht, 
		(ATTRIBUTE.Wert) AS TIERART
	FROM 
		public.TIER, 
		public.TIER_ATTRIBUTE, 
		public.ATTRIBUTE
	WHERE 
		TIER.PK_Tier = TIER_ATTRIBUTE.FK_Tier AND
		TIER_ATTRIBUTE.FK_Attribute = ATTRIBUTE.PK_Attribute AND
		ATTRIBUTE.Wert = 'Haushuhn';
		
CREATE OR REPLACE VIEW "v_Futter" AS
	SELECT 
		FUTTER.PK_Futter,
		FUTTER.Name,
		FUTTER.Preis,
		FUTTER_BESTAND.Bestand,
		(LAGER.PK_LAGER) AS LAGERNUMMER,
		LAGER.LAGERART
	FROM
		public.FUTTER,
		public.FUTTER_BESTAND,
		public.LAGER
	WHERE
		FUTTER.PK_Futter = FUTTER_BESTAND.FK_Futter AND
		FUTTER_BESTAND.FK_Lager = LAGER.PK_Lager;

CREATE OR REPLACE VIEW "v_Duenger" AS
	SELECT
		DUENGER.PK_Duenger,
		DUENGER.Name,
		DUENGER.Preis,
		DUENGER_BESTAND.Bestand,
		(LAGER.PK_LAGER) AS LAGERNUMMER,
		LAGER.LAGERART
	FROM
		public.DUENGER,
		public.DUENGER_BESTAND,
		public.LAGER
	WHERE
		DUENGER.PK_Duenger = DUENGER_BESTAND.FK_Duenger AND
		DUENGER_BESTAND.FK_Lager = LAGER.PK_Lager;
