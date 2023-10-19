#colors
RED = \033[0;31m
NC = \033[0m


REQUIREMENTS = srcs/requirements/

PATH_NGINX = $(REQUIREMENTS)nginx
PATH_MARIADB = $(REQUIREMENTS)mariadb

.PHONY: all
all:
	echo "all nothing to do"

.PHONY: clean
clean:
	echo "clean nothing to do"

.PHONY: fclean
fclean: clean
	echo "fclean nothing to do"

.PHONY: re
re: fclean
	$(MAKE) all


.PHONY: testNginx
testNginx:
	docker stop nginx-test && docker rm nginx-test || true
	docker build -t nginx-test $(PATH_NGINX)
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
