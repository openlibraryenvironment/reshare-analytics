#!/bin/bash
set -e
cd sql/derived_tables
ls -l runlist.txt
for f in $( cat runlist.txt ); do
	if ! PGOPTIONS='--client-min-messages=warning' psql -d reshare_dev -bq -v ON_ERROR_STOP=on -c 'set search_path = reshare_derived' -f $f ; then
		exit 1
	fi
done || exit 1
