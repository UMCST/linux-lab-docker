\set guac_passwd `echo \'$GUAC_PASSWORD\'`
CREATE DATABASE guacdb;
CREATE USER guac WITH PASSWORD :guac_passwd;
GRANT ALL PRIVILEGES ON DATABASE guacdb TO guac;
