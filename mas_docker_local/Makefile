SHELL := /bin/bash

default: run-beers

run:
	source .custom.env; DB_HOST_REPLACE=$(sed -e "s~YOUR_SSG~${MAS_HOSTNAME}~g" files/mas/dbinit/04_mag_otk_db_data.sql); echo "${DB_HOST_REPLACE}" > files/mas/dbinit/04_mag_otk_db_data.sql; docker-compose -f docker-compose.yml up -d

log:
	source .custom.env; docker-compose -f docker-compose.yml logs -f

clean: 
	source .custom.env; docker-compose -f docker-compose.yml stop && docker-compose -f docker-compose.yml rm -f && docker volume prune -f

run-beers: run
	source .custom.env; docker-compose -f docker-compose.beers.yml up -d

log-beers: log
	source .custom.env; docker-compose -f docker-compose.yml -f docker-compose.beers.yml logs -f

clean-beers: clean
	source .custom.env; docker-compose -f docker-compose.beers.yml stop && docker-compose -f docker-compose.beers.yml rm -f && docker volume prune -f

run-mas:
	source .custom.env; docker-compose -f docker-compose.mas.yml up -d

log-mas:
	source .custom.env; docker-compose -f docker-compose.yml -f docker-compose.mas.yml logs -f

clean-mas:
	source .custom.env; docker-compose -f docker-compose.mas.yml stop && docker-compose -f docker-compose.mas.yml rm -f && docker volume prune -f

run-all: run-beers

log-all:
	source .custom.env; docker-compose -f docker-compose.yml -f docker-compose.beers.yml logs -f

clean-all: clean-beers
