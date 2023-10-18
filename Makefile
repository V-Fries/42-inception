
REQUIREMENTS = srcs/requirements/

PATH_NGINX = $(REQUIREMENTS)nginx

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