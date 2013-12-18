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

