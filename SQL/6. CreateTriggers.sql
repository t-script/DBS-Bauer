CREATE OR REPLACE FUNCTION
	usp_CheckBestand()
	RETURNS TRIGGER
	AS $$

DECLARE
	_Lagergroesse integer := (SELECT Kapazitaet FROM LAGER WHERE PK_LAGER = NEW.FK_Lager);
	_Saatgut_Bestand integer := (
		SELECT 
			CASE WHEN sum(Bestand) IS NULL THEN 0 ELSE sum(Bestand) END
		FROM 
			Saatgut_Bestand 
		WHERE Saatgut_Bestand.FK_Lager = NEW.FK_Lager
	);
	_Futter_Bestand integer := (
		SELECT 
			CASE WHEN sum(Bestand) IS NULL THEN 0 ELSE sum(Bestand) END 
		FROM Futter_Bestand 
		WHERE Futter_Bestand.FK_Lager = NEW.FK_Lager
	);
	_Duenger_Bestand integer := (
		SELECT
			CASE WHEN sum(Bestand) IS NULL THEN 0 ELSE sum(Bestand) END 
		FROM Duenger_Bestand 
		WHERE Duenger_Bestand.FK_Lager = NEW.FK_Lager
	);
	_Lager_Bestand integer := (_Saatgut_Bestand + _Futter_Bestand + _Duenger_Bestand);
	_Unterschied INTEGER;
BEGIN
	/* DEBUG
	RAISE NOTICE '_Lagergroesse %', _Lagergroesse;
	RAISE NOTICE '_Saatgut_Bestand %', _Saatgut_Bestand;
	RAISE NOTICE '_Futter_Bestand %', _Futter_Bestand;
	RAISE NOTICE '_Duenger_Bestand %', _Duenger_Bestand;
	RAISE NOTICE '_Lager_Bestand %', _Lager_Bestand;
	RAISE NOTICE 'NEW %', NEW.FK_Lager;
	RAISE NOTICE 'NEW %', NEW.Bestand;*/
	
	IF(TG_OP = 'UPDATE') THEN
		_Unterschied := NEW.Bestand - OLD.Bestand;
		IF(_Lagergroesse >= (_Lager_Bestand + _Unterschied)) THEN
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Lagerkapazität überschritten';
			RETURN OLD;
		END IF;
	ELSIF(TG_OP = 'INSERT') THEN
		IF(_Lagergroesse >= (_Lager_Bestand + NEW.Bestand)) THEN
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Lagerkapazität überschritten';
			RETURN OLD;	
		END IF;
	END IF;
	
	
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
	usp_CheckMaschine()
	RETURNS TRIGGER
	AS $$

DECLARE
	_Lagergroesse integer := (SELECT Kapazitaet FROM LAGER WHERE PK_LAGER = NEW.FK_Lager);
	_MaschinenImLager integer := (SELECT count(*) FROM MASCHINE WHERE MASCHINE.FK_Lager = NEW.FK_Lager);
BEGIN
	IF(_Lagergroesse >= (_MaschinenImLager + 1)) THEN
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'Lagerkapazität überschritten';
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER TR_LagerFutter
	BEFORE INSERT OR UPDATE
	ON FUTTER_BESTAND
	FOR EACH ROW
	EXECUTE PROCEDURE usp_CheckBestand();

CREATE TRIGGER TR_LagerSaatgut
	BEFORE INSERT OR UPDATE
	ON SAATGUT_BESTAND
	FOR EACH ROW
	EXECUTE PROCEDURE usp_CheckBestand();

CREATE TRIGGER TR_LagerDuenger
	BEFORE INSERT OR UPDATE
	ON DUENGER_BESTAND
	FOR EACH ROW
	EXECUTE PROCEDURE usp_CheckBestand();
	
--INSERT INTO FUTTER_BESTAND VALUES(1,1, 400);
--INSERT INTO DUENGER_BESTAND VALUES(1,2, 1);
--UPDATE DUENGER_BESTAND SET Bestand = 1000 WHERE FK_Duenger = 3;

CREATE TRIGGER TR_LagerMaschine
	BEFORE INSERT
	ON Maschine
	FOR EACH ROW
	EXECUTE PROCEDURE usp_CheckMaschine();

--INSERT INTO LAGER(lagerart, kapazitaet) values('garage', 1);
--INSERT INTO MASCHINE(fk_lager,name) values(6,'testauto');

	