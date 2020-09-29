include .env
export

up:
	docker-compose up -d

stop:
	docker-compose stop

bash:
	docker-compose run --rm rails bash

test:
	docker-compose run --rm rails bin/rails t

guard:
	docker-compose run --rm rails bundle exec guard

cluster-create:
	terraform init ./terraform
	terraform apply -var "do_token=$(DO_TOKEN)" ./terraform

cluster-destroy:
	terraform adestroy ./terraform

.PHONY: test
.DEFAULT_GOAL:= up
