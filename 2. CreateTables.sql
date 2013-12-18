CREATE TABLE TIER (
        PK_Tier                     SERIAL PRIMARY KEY,
        FK_Stall					SERIAL REFERENCES STALL (PK_Stall),
        Name                        VARCHAR(50) NOT NULL,
        Geburtsdatum                DATE NOT NULL,
        Anschaffungs_Datum			DATE NOT NULL,
        Gewicht                     SMALLINT
);

CREATE TABLE SCHWEIN (
        PK_Schwein					SERIAL PRIMARY KEY,
        FK_Tier                     SERIAL REFERENCES TIER (PK_Tier),
        Schlachttermin              DATE
);

CREATE TABLE KUH (
        PK_KUH                      SERIAL PRIMARY KEY,
        FK_Tier                     SERIAL REFERENCES TIER (PK_Tier),
        Milchmenge_avg              NUMERIC(5,2)
);

CREATE TABLE HUHN (
        PK_HUHN                     SERIAL PRIMARY KEY,
        FK_Tier                     SERIAL SERIAL REFERENCES TIER (PK_Tier),
        Eier_avg					SMALLINT
);
        
CREATE TABLE STALL (
        PK_Stall					SERIAL PRIMARY KEY,
        Stallart					VARCHAR(50),
        Kapazität					SMALLINT NOT NULL,
        Standor						VARCHAR(50) NOT NULL
);

CREATE TABLE TIERARZTBESUCH (
        PK_Tierarztbesuch			SERIAL PRIMARY KEY,
        FK_Tier                     SERIAL NOT NULL,
        Datum                       DTAE,
        Diagnose					TEXT,
        Medikamente					VARCHAR(100)
);

CREATE TABLE FUTTERMENGE_PRO_TIER (
        FK_Tier						SERIAL SERIAL REFERENCES TIER (PK_Tier),
        FK_Futter					SERIAL REFERENCES FUTTER (PK_Futter),
        Datum_von					DATE,
        Datum_bis					DATE
);

CREATE TABLE FUTTER (
        PK_Futter					SERIAL PRIMARY KEY,
        Name                        VARCHAR(50),
        Preis                       MONEY
);

CREATE TABLE DÜNGER (
        PK_Dünger					SERIAL PRIMARY KEY,
        Name                        VARCHAR(50),
        Preis                       MONEY
);

CREATE TABLE SAATGUT (
        PK_Saatgut					SERIAL PRIMARY KEY,
        Name                        VARCHAR(50),
        Preis                       MONEY
);

CREATE TABLE FUTTER_BESTAND (
        FK_Futter					SERIAL REFERENCES FUTTER (PK_Futter),
        FK_Lager					SERIAL REFERENCES LAGER (PK_Lager),
        Bestand						SMALLINT
);

CREATE TABLE DÜNGER_BESTAND (
        FK_Dünger					SERIAL REFERENCES DÜNGER (PK_Dünger),
        FK_Lager					SERIAL REFERENCES LAGER (PK_Lager),
        Bestand						SMALLINT
);

CREATE TABLE SAATGUT_BESTAND (
        FK_Saatgut					SERIAL REFERENCES SAATGUT (PK_Saatgut),
        FK_Lager					SERIAL REFERENCES LAGER (PK_Lager),
        Bestand						SMALLINT
);

CREATE TABLE LAGER (
        PK_Lager					SERIAL PRIMARY KEY,
        Lagerart					VAHRCHAR(50),
        Kapazität					SMALLINT
);

CREATE TABLE ACKER (
        PK_Acker					SERIAL PRIMARY KEY,
        Größe                       SMALLINT
);

CREATE TABLE ACKERDATEN (
        FK_Acker					SERIAL REFERENCES ACKER (PK_Acker),
        FK_Dünger					SERIAL REFERENCES DÜNGER (PK_Dünger),
        FK_Saatgut					SERIAL REFERENCES SAATGUT (PK_Saatgut),
        Datum                       DATE
        MESSWERT                    NUMERIC(15,5)
);


CREATE TYPE geschlecht AS ENUM ('männlich' , 'weiblich');
CREATE TABLE ANGESTELLTER (
        PK_Angestellter				SERIAL PRIMARY KEY,
        Vorname                     VARCHAR(50) NOT NULL,
        Nachname					VARCHAR(50) NOT NULL,
        SVN							VARCHAR(30) NOT NULL,
        Gehalt                      MONEY NOT NULL,
        Bankdaten					VARCHAR(50),
        Geschlecht					geschlecht
);

CREATE TABLE MASCHINE (
        PK_Maschine					SERIAL PRIMARY KEY,
        FK_Lager					SERIAL REFERENCES LAGER (PK_Lager),
        Kosten                      MONEY,
        Abschreibungsdatum			DATE,
        Anschaffungsdatum			DATE,
        Typ							VARCHAR(50),
        Name                        VARCHAR(50)
);

CREATE TABLE MASCHINE_VERWENDUNG (
        FK_Angestellter				SERIAL REFERENCES ANGESTELLTER (PK_Angestellter),
        FK_Maschine					SERIAL REFERENCES MASCHINE (PK_Maschine),
        Verwendungsdatum			DATE,
        Dauer                       SMALLINT
);

CREATE TABLE ANGESTELLTER_STALLARBEITEN (
        FK_Stall					SERIAL REFERENCES STALL (PK_STALL),
        FK_Angestellter				SERIAL REFERENCES ANGESTELLTER (PK_Angestellter),
        VerichteteArbeit			TEXT,
        Datum                       DATE,
        Dauer                       SMALLINT
);