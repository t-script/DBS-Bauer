CREATE ROLE R_Angestellte; 

GRANT ALL ON ALL TABLES IN SCHEMA public TO R_Angestellte;
REVOKE ALL On Angestellter FROM R_Angestellte;
--REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM R_Angestellte;

CREATE USER joe	PASSWORD 'joe' ;
GRANT R_Angestellte TO joe;