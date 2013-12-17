IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'bauerDb') THEN
	RAISE EXCEPTION 'Datenbank wurde bereits erstellt';
END IF ;

CREATE DATABASE bauerDb
	WITH
		OWNER bauerAdmin
		TEMPLATE template1
		ENCODING 'UTF8'
		TABLESPACE pg_default
		CONNECTION LIMIT -1;
\c bauerDb

CREATE TABLE TIER (
	PK_Tier			serial PRIMARY KEY,
	FK_Stall		serial NOT NULL,
	Name			text,
	Geburtsdatum		date NOT NULL,
	Anschaffungs_Datum	date NOT NULL,
	Gewicht			smallint
);

CREATE TABLE SCHWEIN (
	PK_Schwein		serial PRIMARY KEY,
	FK_Tier			serial NOT NULL,
	Schlachttermin		date
);

CREATE TABLE KUH (
	PK_KUH			serial PRIMARY KEY,
	FK_Tier			serial NOT NULL,
	Milchmenge_avg		numeric(5,2)
);

CREATE TABLE HUHN (
	PK_HUHN			serial PRIMARY KEY,
	FK_Tier			serial NOT NULL,
	Eier_avg		smallint
);
	
CREATE TABLE STALL (
	PK_Stall		serial PRIMARY KEY,
	Stallart		text,
	Kapazität		text NOT NULL,
	Standort		text NOT NULL
);

CREATE TABLE TIERARZTBESUCH (
	PK_Tierarztbesuch	serial PRIMARY KEY,
	FK_Tier			serial NOT NULL,
	Datum			date,
	Diagnose		text,
	Medikamente		text
);

CREATE TABLE FUTTERMENGE_PRO_TIER (
	FK_Tier			serial NOT NULL,
	FK_Futter		serial NOT NULL,
	Datum_von		date,
	Datum_bis		date
);

CREATE TABLE FUTTER (
	PK_Futter		serial PRIMARY KEY,
	Name			text,
	Preis			money
);

CREATE TABLE DÜNGER (
	PK_Dünger		serial PRIMARY KEY,
	Name			text,
	Preis			money
);

CREATE TABLE SAATGUT (
	PK_Saatgut		serial PRIMARY KEY,
	Name			text,
	Preis			money
);

CREATE TABLE FUTTER_BEST	AND (
	FK_Futter		serial NOT NULL,
	FK_Lager		serial NOT NULL,
	Bestand 		integer
);

CREATE TABLE DÜNGER_BEST	AND (
	FK_Dünger 		serial NOT NULL,
	FK_Lager		serial NOT NULL,
	Bestand 		integer
);

CREATE TABLE SAATGUT_BES	TAND (
	FK_Saatgut 		serial NOT NULL,
	FK_Lager		serial NOT NULL,
	Bestand 		integer
);

CREATE TABLE LAGER (
	PK_Lager		serial PRIMARY KEY,
	Lagerart		text,
	Kapazität		text
);

CREATE TABLE ACKER (
	PK_Acker		serial PRIMARY KEY,
	Größe			integer
);

CREATE TABLE ACKERDATEN (
	FK_Acker		serial NOT NULL,
	FK_Dünger 		serial NOT NULL,
	FK_Saatgut 		serial NOT NULL,
	Datum			date,
	Meßwert			numeric(15,5)
);

-- TODO: add constraints GESCHLECHT
CREATE TABLE ANGESTELLTER (
	PK_Angestellter		serial PRIMARY KEY,
	Vorname			text NOT NULL,
	Nachname		text NOT NULL,
	SVN			text NOT NULL,
	Gehalt			money NOT NULL,
	Bankdaten		text,
	Geschlecht		text
);

CREATE TABLE MASCHINE (
	PK_Maschine		serial PRIMARY KEY,
	FK_Lager		serial NOT NULL,
	Kosten			money,
	Abschreibungsdatum	date,
	Anschaffungsdatum	date,
	Typ			text,
	Name			text
);

CREATE TABLE MASCHINE_VERWENDUNG (
	FK_Angestellter		serial NOT NULL,
	FK_Maschine		serial NOT NULL,
	Verwendungsdatum	date,
	Dauer			integer
);

CREATE TABLE ANGESTELLTER_STALLARBEITEN (
	FK_Stall		serial NOT NULL,
	FK_Angestellter		serial NOT NULL,
	VerichteteArbeit	text,
	Datum			date,
	Dauer			integer
);

