up:
	docker-compose up -d

bash:
	docker-compose run rails bash

.PHONY: up
.DEFAULT_GOAL:= up