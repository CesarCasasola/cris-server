#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER dspace WITH PASSWORD 'dsp4c3cr1s';
	CREATE DATABASE dspace WITH OWNER 'dspace';
	GRANT ALL PRIVILEGES ON DATABASE dspace TO dspace;

	\c dspace
	CREATE EXTENSION pgcrypto;
EOSQL

