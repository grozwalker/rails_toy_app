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

.PHONY: test
.DEFAULT_GOAL:= up
