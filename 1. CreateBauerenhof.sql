\set ON_ERROR_STOP 1

DO $$
BEGIN
	IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'bauerdb') THEN
		RAISE EXCEPTION 'Datenbank wurde bereits erstellt';
	END IF;
END$$;

CREATE ROLE baueradmin 
	PASSWORD 'bauer'  
	NOSUPERUSER 
	NOCREATEDB 
	CREATEROLE 
	INHERIT 
	LOGIN;

CREATE DATABASE bauerdb
	WITH
		OWNER baueradmin
		TEMPLATE template1
		ENCODING 'UTF8'
		TABLESPACE pg_default
		CONNECTION LIMIT -1;
