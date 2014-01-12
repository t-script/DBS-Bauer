DROP TABLE IF EXISTS STALL CASCADE; 
CREATE TABLE STALL (
	PK_Stall		serial PRIMARY KEY,
	Stallart		text,
	Kapazitaet		text NOT NULL, -- gesamtkapazität tiere
	Standort		text NOT NULL -- relative angabe mit referenz auf haupthof oder absolute angabe nach offiziellen ortsangaben
);

DROP TABLE IF EXISTS FUTTER CASCADE;
CREATE TABLE FUTTER (
	PK_Futter		serial PRIMARY KEY,
	Name			text,
	Preis			float -- €/kg
);

DROP TABLE IF EXISTS DUENGER CASCADE;
CREATE TABLE DUENGER (
	PK_Duenger		serial PRIMARY KEY,
	Name			text,
	Preis			float -- €/kg
);

DROP TABLE IF EXISTS SAATGUT CASCADE;
CREATE TABLE SAATGUT (
	PK_Saatgut		serial PRIMARY KEY,
	Name			text,
	Preis			float -- €/kg
);

DROP TABLE IF EXISTS LAGER CASCADE;
CREATE TABLE LAGER (
	PK_Lager		serial PRIMARY KEY,
	Lagerart		text,
	Kapazitaet		integer -- kg
);

DROP TABLE IF EXISTS ACKER CASCADE;
CREATE TABLE ACKER (
	PK_Acker		serial PRIMARY KEY,
	Standort		text,
	Groesse			integer -- m²
);

DO $$
BEGIN
	IF (SELECT 1 FROM pg_type WHERE typname = 'geschlecht') THEN
	ELSE
		CREATE TYPE geschlecht AS ENUM ('maennlich' , 'weiblich');
	END IF;
END$$;

DROP TABLE IF EXISTS ANGESTELLTER CASCADE;
CREATE TABLE ANGESTELLTER (
	PK_Angestellter		serial PRIMARY KEY,
	Vorname			text NOT NULL,
	Nachname		text NOT NULL,
	SVN			text NOT NULL,
	Gehalt			float NOT NULL,
	Bankdaten		text,
        Geschlecht		geschlecht
);

DROP TABLE IF EXISTS MASCHINE CASCADE;
CREATE TABLE MASCHINE (
	PK_Maschine		serial PRIMARY KEY,
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Kosten			float, -- €
	Anschaffungsdatum	date,
	Abschreibungsdatum	date,
	Typ			text,
	Name			text
);

DROP TABLE IF EXISTS TIER CASCADE;
CREATE TABLE TIER (
	PK_Tier			serial PRIMARY KEY,
	FK_Stall		serial REFERENCES STALL (PK_Stall),
	Name			text, -- name des tieres (falls es überhaupt einen hat) -- bsp. Berta
	Geburtsdatum		date NOT NULL,
	Anschaffungsdatum	date NOT NULL,
	Gewicht			float -- kg
);

DROP TABLE IF EXISTS ATTRIBUTE CASCADE;
CREATE TABLE ATTRIBUTE (
	PK_Attribute		serial PRIMARY KEY,
	Name			text, -- bsp.: Tierart
	Wert			text -- bsp.: Hausschwein
);

DROP TABLE IF EXISTS TIER_ATTRIBUTE CASCADE;
CREATE TABLE TIER_ATTRIBUTE (
	FK_Tier			serial REFERENCES TIER (PK_Tier),
	FK_Attribute		serial REFERENCES ATTRIBUTE (PK_Attribute)
);

DROP TABLE IF EXISTS TIERARZTBESUCH CASCADE;
CREATE TABLE TIERARZTBESUCH (
	PK_Tierarztbesuch	serial PRIMARY KEY,
	FK_Tier			serial REFERENCES TIER (PK_Tier),
	Datum			date,
	Diagnose		text,
	Medikamente		text
);

DROP TABLE IF EXISTS FUTTERMENGE_PRO_TIER CASCADE;
CREATE TABLE FUTTERMENGE_PRO_TIER (
        FK_Tier			serial REFERENCES TIER (PK_Tier),
        FK_Futter		serial REFERENCES FUTTER (PK_Futter),
        Menge			float NOT NULL, -- kg/day
	Datum			date DEFAULT now()
);

DROP TABLE IF EXISTS FUTTER_BESTAND CASCADE;
CREATE TABLE FUTTER_BESTAND (
        FK_Futter		serial REFERENCES FUTTER (PK_Futter),
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Bestand 		integer
);

DROP TABLE IF EXISTS DUENGER_BESTAND CASCADE;
CREATE TABLE DUENGER_BESTAND (
        FK_Duenger		serial REFERENCES DUENGER (PK_Duenger),
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Bestand 		integer
);

DROP TABLE IF EXISTS SAATGUT_BESTAND CASCADE;
CREATE TABLE SAATGUT_BESTAND (
        FK_Saatgut		serial REFERENCES SAATGUT (PK_Saatgut),
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Bestand 		integer
);

DROP TABLE IF EXISTS ACKERDATEN CASCADE;
CREATE TABLE ACKERDATEN (
        FK_Acker		serial REFERENCES ACKER (PK_Acker),
        FK_Duenger		serial REFERENCES DUENGER (PK_Duenger),
        FK_Saatgut		serial REFERENCES SAATGUT (PK_Saatgut),
	Datum			date, -- datum der aussaat
	Messwert		float
);

DROP TABLE IF EXISTS MASCHINE_VERWENDUNG CASCADE;
CREATE TABLE MASCHINE_VERWENDUNG (
        FK_Angestellter		serial REFERENCES ANGESTELLTER (PK_Angestellter),
        FK_Maschine		serial REFERENCES MASCHINE (PK_Maschine),
	Verwendungsdatum	date,
	Dauer			Interval -- h
);

DROP TABLE IF EXISTS ANGESTELLTER_STALLARBEITEN CASCADE;
CREATE TABLE ANGESTELLTER_STALLARBEITEN (
        FK_Stall		serial REFERENCES STALL (PK_Stall),
        FK_Angestellter		serial REFERENCES ANGESTELLTER (PK_Angestellter),
	VerrichteteArbeit	text,
	Datum			date,
	Dauer			Interval -- h
);

