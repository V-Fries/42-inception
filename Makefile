include srcs/.env

DOCKER_COMPOSE_PATH = srcs/docker-compose.yml

.PHONY: all
all:
	mkdir -p $(WORDPRESS_VOLUME)
	mkdir -p $(MARIADB_VOLUME)
	docker compose -f $(DOCKER_COMPOSE_PATH) up -d --build

.PHONY: stop
stop:
	docker compose -f $(DOCKER_COMPOSE_PATH) stop

.PHONY: clean
clean: stop
	docker compose -f $(DOCKER_COMPOSE_PATH) down -v

.PHONY: prune
prune:
	docker system prune -af

.PHONY: re
re: clean
	$(MAKE) all

.PHONY: deletePersistentData
deletePersistentData: clean
	rm -rf $(WORDPRESS_VOLUME)
	rm -rf $(MARIADB_VOLUME)

.PHONY: reDeletePersistentData
reDeletePersistentData: deletePersistentData
	$(MAKE) all
