#!/usr/bin/env bash
psql -c 'create database herigone_test;' -U postgres;
psql -c 'create user herigone_test with createdb;' -U postgres;
psql -c "alter user herigone_test with password 'kusipojat';" -U postgres;
psql -c 'grant all on database herigone_test to herigone_test;' -U postgres;
