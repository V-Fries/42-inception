#colors
RED = \033[0;31m
NC = \033[0m


REQUIREMENTS = srcs/requirements/

PATH_NGINX = $(REQUIREMENTS)nginx
PATH_MARIADB = $(REQUIREMENTS)mariadb
PATH_WORDPRESS = $(REQUIREMENTS)wordpress

.PHONY: all
all:
	docker-compose -f srcs/docker-compose.yml up -d --build

.PHONY: stop
stop:
	docker-compose -f srcs/docker-compose.yml stop

.PHONY: clean
clean: stop
	docker-compose -f srcs/docker-compose.yml down -v

#.PHONY: fclean
fclean: clean
#	docker system prune -af

.PHONY: re
re: fclean
	$(MAKE) all


.PHONY: testNginx
testNginx:
	@echo "$(RED)Delete nginx-test container if exist $(NC)"
	docker stop nginx-test && docker rm nginx-test || true
	@echo "$(RED)Building nginx-test IMG $(NC)"
	docker build -t nginx-test $(PATH_NGINX)
	@echo "$(RED)Running nginx-test container $(NC)"
	docker run -d -p 443:443 --name nginx-test nginx-test

.PHONY: testMariadb
testMariadb:
	@echo "$(RED)Delete mariadb-test container if exist $(NC)"
	docker stop mariadb-test && docker rm mariadb-test || true
	@echo "$(RED)Building mariadb-test IMG $(NC)"
	docker build --build-arg SQL_DATABASE_NAME=test \
				 --build-arg SQL_USER_NAME=test \
				 --build-arg SQL_USER_PASSWORD=test \
				 --build-arg SQL_ROOT_PASSWORD=test \
				 -t mariadb-test \
				 $(PATH_MARIADB)
	@echo "$(RED)Running mariadb-test container $(NC)"
	docker run -it --name mariadb-test mariadb-test

.PHONY: testWordpress
testWordpress:
	@echo "$(RED)Delete wordpress-test container if exist $(NC)"
	docker stop wordpress-test && docker rm wordpress-test || true
	@echo "$(RED)Building wordpress-test IMG $(NC)"
	docker build --build-arg SQL_DATABASE_NAME=test \
				 --build-arg SQL_USER_NAME=test \
				 --build-arg SQL_USER_PASSWORD=test \
				 -t wordpress-test \
				 $(PATH_WORDPRESS)
	@echo "$(RED)Running wordpress-test container $(NC)"
	docker run -it --name wordpress-test wordpress-test
