SHELL := /bin/bash

default: run

derby: 
	docker-compose -f gateway-derby.yml up -d

hazelcast-cluster:
	docker-compose -f hazelcast.yml up -d

gwhazelcast:
	docker-compose -f gateway-hazelcast.yml up -d

log:
	docker-compose -f hazelcast.yml -f gateway-derby.yml -f gateway-hazelcast.yml logs -f

log-hazelcast:
	docker-compose -f hazelcast.yml logs -f

log-derby:
	docker-compose -f gateway-derby.yml logs -f

log-gwhazelcast:
	docker-compose -f gateway-hazelcast.yml logs -f

clean-derby:
	docker-compose -f gateway-derby.yml stop && docker-compose -f gateway-derby.yml rm -f && docker volume prune -f

clean-hazelcast:
	docker-compose -f hazelcast.yml stop && docker-compose -f hazelcast.yml rm -f

clean-gwhazelcast:
	docker-compose -f gateway-hazelcast.yml stop && docker-compose -f gateway-hazelcast.yml rm -f && docker volume prune -f

run:
	docker-compose -f hazelcast.yml up -d && docker-compose -f gateway-hazelcast.yml up -d

clean: clean-derby clean-hazelcast clean-gwhazelcast
