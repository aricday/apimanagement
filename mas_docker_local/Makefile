SHELL := /bin/bash

default: run

run:
	source .custom.env; docker-compose -f docker-compose.yml up -d

log:
	source .custom.env; docker-compose -f docker-compose.yml logs -f

clean: 
	source .custom.env; docker-compose -f docker-compose.yml stop && docker-compose -f docker-compose.yml rm -f && docker volume prune -f && docker network prune -f
