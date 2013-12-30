-- drop schema public cascade;
-- create schema public;

CREATE TABLE STALL (
	PK_Stall		serial PRIMARY KEY,
	Stallart		text,
	Kapazitaet		text NOT NULL, -- gesamtkapazität tiere
	Standort		text NOT NULL -- relative angabe mit referenz auf haupthof oder absolute angabe nach offiziellen ortsangaben
);

CREATE TABLE FUTTER (
	PK_Futter		serial PRIMARY KEY,
	Name			text,
	Preis			float -- €/kg
);

CREATE TABLE DUENGER (
	PK_DUEnger		serial PRIMARY KEY,
	Name			text,
	Preis			float -- €/kg
);

CREATE TABLE SAATGUT (
	PK_Saatgut		serial PRIMARY KEY,
	Name			text,
	Preis			float -- €/kg
);

CREATE TABLE LAGER (
	PK_Lager		serial PRIMARY KEY,
	Lagerart		text,
	Kapazitaet		integer -- kg
);

CREATE TABLE ACKER (
	PK_Acker		serial PRIMARY KEY,
	Groesse			integer -- m²
);

CREATE TYPE geschlecht AS ENUM ('maennlich' , 'weiblich');
CREATE TABLE ANGESTELLTER (
	PK_Angestellter		serial PRIMARY KEY,
	Vorname			text NOT NULL,
	Nachname		text NOT NULL,
	SVN			text NOT NULL,
	Gehalt			float NOT NULL,
	Bankdaten		text,
        Geschlecht		geschlecht
);

CREATE TABLE MASCHINE (
	PK_Maschine		serial PRIMARY KEY,
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Kosten			float, -- €
	Anschaffungsdatum	date,
	Abschreibungsdatum	date,
	Typ			text,
	Name			text
);

CREATE TABLE TIER (
	PK_Tier			serial PRIMARY KEY,
	FK_Stall		serial REFERENCES STALL (PK_Stall),
	Name			text, -- name des tieres (falls es überhaupt einen hat) -- bsp. Berta
	Geburtsdatum		date NOT NULL,
	Anschaffungs_Datum	date NOT NULL,
	Gewicht			float -- kg
);

CREATE TABLE ATTRIBUTE (
	PK_Attribute		serial PRIMARY KEY,
	Name			text, -- bsp.: Tierart
	Wert			text -- bsp.: Hausschwein
);

CREATE TABLE TIER_ATTRIBUTE (
	FK_Tier			serial REFERENCES TIER (PK_Tier),
	FK_Attribute		serial REFERENCES ATTRIBUTE (PK_Attribute)
);

CREATE TABLE TIERARZTBESUCH (
	PK_Tierarztbesuch	serial PRIMARY KEY,
	FK_Tier			serial REFERENCES TIER (PK_Tier),
	Datum			date,
	Diagnose		text,
	Medikamente		text
);

CREATE TABLE FUTTERMENGE_PRO_TIER (
        FK_Tier			serial REFERENCES TIER (PK_Tier),
        FK_Futter		serial REFERENCES FUTTER (PK_Futter),
        Menge			float NOT NULL, -- kg/day
	Datum			date DEFAULT now()
);

CREATE TABLE FUTTER_BESTAND (
        FK_Futter		serial REFERENCES FUTTER (PK_Futter),
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Bestand 		integer
);

CREATE TABLE DUENGER_BESTAND (
        FK_Duenger		serial REFERENCES DUENGER (PK_Duenger),
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Bestand 		integer
);

CREATE TABLE SAATGUT_BESTAND (
        FK_Saatgut		serial REFERENCES SAATGUT (PK_Saatgut),
        FK_Lager		serial REFERENCES LAGER (PK_Lager),
	Bestand 		integer
);

CREATE TABLE ACKERDATEN (
        FK_Acker		serial REFERENCES ACKER (PK_Acker),
        FK_Duenger		serial REFERENCES DUENGER (PK_Duenger),
        FK_Saatgut		serial REFERENCES SAATGUT (PK_Saatgut),
	Datum			date, -- datum der aussaat
	Messwert		float
);

CREATE TABLE MASCHINE_VERWENDUNG (
        FK_Angestellter		serial REFERENCES ANGESTELLTER (PK_Angestellter),
        FK_Maschine		serial REFERENCES MASCHINE (PK_Maschine),
	Verwendungsdatum	date,
	Dauer			float -- h
);

CREATE TABLE ANGESTELLTER_STALLARBEITEN (
        FK_Stall		serial REFERENCES STALL (PK_Stall),
        FK_Angestellter		serial REFERENCES ANGESTELLTER (PK_Angestellter),
	VerichteteArbeit	text,
	Datum			date,
	Dauer			float -- h
);

