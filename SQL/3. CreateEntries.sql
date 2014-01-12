TRUNCATE STALL CASCADE;
TRUNCATE ANGESTELLTER CASCADE;
TRUNCATE TIER CASCADE;
TRUNCATE LAGER CASCADE;
TRUNCATE FUTTER CASCADE;
TRUNCATE DUENGER CASCADE;
TRUNCATE ATTRIBUTE CASCADE;
TRUNCATE SAATGUT CASCADE;

INSERT INTO STALL(Stallart, Kapazitaet, Standort) VALUES ('Schweinestall', '1500', 'Nebenhof');
INSERT INTO STALL(Stallart, Kapazitaet, Standort) VALUES ('Kuhstall', '1500', 'Haupthof');
INSERT INTO STALL(Stallart, Kapazitaet, Standort) VALUES ('Hühnerstall', '1500', 'Haupthof');

INSERT INTO ATTRIBUTE(Name, Wert) VALUES ('Tierart', 'Hausschwein');
INSERT INTO ATTRIBUTE(Name, Wert) VALUES ('Tierart', 'Hausrind');
INSERT INTO ATTRIBUTE(Name, Wert) VALUES ('Tierart', 'Haushuhn');

INSERT INTO FUTTER(Name, Preis) VALUES ('Medizinfutter', 10);
INSERT INTO FUTTER(Name, Preis) VALUES ('Wachtumsfutter', 5);
INSERT INTO FUTTER(Name, Preis) VALUES ('Hühnerfutter', 1);
INSERT INTO FUTTER(Name, Preis) VALUES ('Heu', 0.5);

INSERT INTO DUENGER(Name, Preis) VALUES ('Schweinedung', 0);
INSERT INTO DUENGER(Name, Preis) VALUES ('Kuhdung', 0);
INSERT INTO DUENGER(Name, Preis) VALUES ('Pestizid', 12);
INSERT INTO DUENGER(Name, Preis) VALUES ('Wachstumsdünger', 5);

INSERT INTO SAATGUT(Name, Preis) VALUES ('Mais', 3);
INSERT INTO SAATGUT(Name, Preis) VALUES ('Genmais', 1.5);
INSERT INTO SAATGUT(Name, Preis) VALUES ('Getreide', 1);
INSERT INTO SAATGUT(Name, Preis) VALUES ('Karotten', 2);
INSERT INTO SAATGUT(Name, Preis) VALUES ('Zuckerrübe', 3);
INSERT INTO SAATGUT(Name, Preis) VALUES ('Erdäpfel', 2.5);

INSERT INTO LAGER(Lagerart, Kapazitaet) VALUES ('Silo', 100000);
INSERT INTO LAGER(Lagerart, Kapazitaet) VALUES ('Dachspeicher', 500);
INSERT INTO LAGER(Lagerart, Kapazitaet) VALUES ('Scheune', 100);
INSERT INTO LAGER(Lagerart, Kapazitaet) VALUES ('Großspeicher', 5000);
INSERT INTO LAGER(Lagerart, Kapazitaet) VALUES ('Saatsilo', 1500);

DO $$

BEGIN
-- Schweine
	FOR i IN 1..1001 LOOP
		INSERT INTO TIER(FK_Stall, Name, Geburtsdatum,Anschaffungsdatum, Gewicht) VALUES(1, null, now(), now(), (i + 200) % 300);
		INSERT INTO TIER_ATTRIBUTE VALUES(currval('tier_pk_tier_seq'), 1);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(currval('tier_pk_tier_seq'), 2, 5);
	END LOOP;
-- Rinder
	FOR i IN 1002..2002 LOOP
		INSERT INTO TIER(FK_Stall, Name, Geburtsdatum,Anschaffungsdatum, Gewicht) VALUES(2, null, now(), now(), (i + 300) % 500);
		INSERT INTO TIER_ATTRIBUTE VALUES(currval('tier_pk_tier_seq'), 2);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(currval('tier_pk_tier_seq'), 2, 3);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(currval('tier_pk_tier_seq'), 4, 3);
		INSERT INTO TIERARZTBESUCH(FK_Tier,Datum, Diagnose, Medikamente) VALUES (currval('tier_pk_tier_seq'), current_date + i % 10, null, null);
	END LOOP;
-- Hühner
	FOR i IN 2003..3003 LOOP
		INSERT INTO TIER(FK_Stall, Name, Geburtsdatum,Anschaffungsdatum, Gewicht) VALUES(3, null, now(), now(), i % 3);
		INSERT INTO TIER_ATTRIBUTE VALUES(currval('tier_pk_tier_seq'), 3);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(currval('tier_pk_tier_seq'), 3, 1.5);
	END LOOP;
END$$;

--SELECT * FROM TIER;
--TRUNCATE STALL CASCADE;

INSERT INTO ANGESTELLTER(Vorname, Nachname, SVN, Gehalt, Bankdaten, Geschlecht) VALUES ('Bartholomeus', 'Kufstein', '2211010203', 1500.75, null, 'maennlich');
INSERT INTO ANGESTELLTER(Vorname, Nachname, SVN, Gehalt, Bankdaten, Geschlecht) VALUES ('Lothar', 'Semmering', '3322020304', 2750.25, null, 'maennlich');
INSERT INTO ANGESTELLTER(Vorname, Nachname, SVN, Gehalt, Bankdaten, Geschlecht) VALUES ('Gertrude', 'Pommern', '4433030405', 2500.50, null, 'weiblich');
INSERT INTO ANGESTELLTER(Vorname, Nachname, SVN, Gehalt, Bankdaten, Geschlecht) VALUES ('Kunigunde', 'Holstein', '5544040506', 1750.25, null, 'weiblich');

INSERT INTO MASCHINE(FK_Lager, Kosten, Anschaffungsdatum, Abschreibungsdatum, Typ, Name) VALUES (3, 75000.0, date '2012-01-01', date '2012-01-01' + 1825, 'Steyr Traktor', '6140 PROFI');
INSERT INTO MASCHINE(FK_Lager, Kosten, Anschaffungsdatum, Abschreibungsdatum, Typ, Name) VALUES (3, 97500.0, date '2012-03-02', date '2012-03-02' + 1825, 'Steyr Traktor', 'multi 4115');
INSERT INTO MASCHINE(FK_Lager, Kosten, Anschaffungsdatum, Abschreibungsdatum, Typ, Name) VALUES (3, 199500.0, date '2011-11-05', date '2011-11-05' + 1825, 'Fendt Mähdrescher', '9490 X AL');

INSERT INTO FUTTER_BESTAND VALUES (1, 4, 200);
INSERT INTO FUTTER_BESTAND VALUES (2, 4, 1000);
INSERT INTO FUTTER_BESTAND VALUES (3, 4, 500);
INSERT INTO FUTTER_BESTAND VALUES (4, 2, 450);

INSERT INTO DUENGER_BESTAND VALUES (3, 4, 1500);
INSERT INTO DUENGER_BESTAND VALUES (4, 4, 1500);

INSERT INTO SAATGUT_BESTAND VALUES (1, 5, 100);
INSERT INTO SAATGUT_BESTAND VALUES (2, 5, 200);
INSERT INTO SAATGUT_BESTAND VALUES (3, 5, 150);
INSERT INTO SAATGUT_BESTAND VALUES (4, 5, 20);
INSERT INTO SAATGUT_BESTAND VALUES (5, 5, 20);
INSERT INTO SAATGUT_BESTAND VALUES (6, 5, 150);

INSERT INTO MASCHINE_VERWENDUNG VALUES (1, 1, now(), '3 hours'::interval);
INSERT INTO MASCHINE_VERWENDUNG VALUES (2, 2, now(), '2 hours'::interval);
INSERT INTO MASCHINE_VERWENDUNG VALUES (3, 3, now(), '5.5 hours'::interval);

INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (1, 4, 'Stall gereinigt', now(), '3.5 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (2, 4, 'Stall gereinigt', now(), '1 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (3, 4, 'Stall gereinigt', now(), '1 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (1, 1, 'Schweine gefüttert', now(), '1.5 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (2, 1, 'Kühe gefüttert', now(), '1 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (3, 1, 'Hühner gefüttert', now(), '1 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (1, 2, 'Anlagen gewartet', now(), '2.5 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (2, 2, 'Anlagen gewartet', now(), '0.5 hours'::interval);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (3, 2, 'Anlagen gewartet', now(), '0.5 hours'::interval);

INSERT INTO ACKER(Standort, Groesse) VALUES ('Nebenhof',2000);
INSERT INTO ACKER(Standort, Groesse) VALUES ('Haupthof',3000);
INSERT INTO ACKER(Standort, Groesse) VALUES ('Haupthof',2500);
INSERT INTO ACKER(Standort, Groesse) VALUES ('Nebenhof',1600);
INSERT INTO ACKER(Standort, Groesse) VALUES ('Haupthof',4000);
INSERT INTO ACKER(Standort, Groesse) VALUES ('Haupthof',3200);
INSERT INTO ACKER(Standort, Groesse) VALUES ('Nebenhof',1050);

INSERT INTO ACKERDATEN VALUES (1,1,1,'1961-06-13',1.312);
INSERT INTO ACKERDATEN VALUES (1,2,2,'1962-02-11',1.312);

INSERT INTO ACKERDATEN VALUES (2,2,2,'1961-06-14',3.442);
INSERT INTO ACKERDATEN VALUES (2,3,3,'1962-02-12',3.442);

INSERT INTO ACKERDATEN VALUES (3,3,3,'1961-06-15',6.572);
INSERT INTO ACKERDATEN VALUES (3,4,4,'1962-02-13',6.572);

INSERT INTO ACKERDATEN VALUES (4,4,4,'1961-06-16',1.602);
INSERT INTO ACKERDATEN VALUES (4,1,5,'1962-02-14',1.602);

INSERT INTO ACKERDATEN VALUES (5,1,5,'1961-06-17',8.722);
INSERT INTO ACKERDATEN VALUES (5,2,6,'1962-02-15',8.722);

INSERT INTO ACKERDATEN VALUES (6,2,6,'1961-06-18',2.002);
INSERT INTO ACKERDATEN VALUES (6,3,1,'1962-02-16',2.002);

INSERT INTO ACKERDATEN VALUES (7,3,1,'1961-06-19',2.712);
INSERT INTO ACKERDATEN VALUES (7,4,4,'1962-02-17',2.712);
