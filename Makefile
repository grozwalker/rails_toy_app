up:
	docker-compose up -d

stop:
	docker-compose stop

bash:
	docker-compose run --rm rails bash

test:
	docker-compose run --rm rails bin/rails test

.PHONY: all test
.DEFAULT_GOAL:= up