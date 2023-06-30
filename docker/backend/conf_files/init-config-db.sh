#!/bin/bash

psql -v ON_ERROR_STOP=1 <<-EOSQL
	CREATE USER dspace WITH PASSWORD 'dsp4c3cr1s';
	CREATE DATABASE dspace WITH ENCODING 'UTF8' OWNER 'dspace';
	GRANT ALL PRIVILEGES ON DATABASE dspace TO dspace;

	\c dspace
	CREATE EXTENSION pgcrypto;
EOSQL

