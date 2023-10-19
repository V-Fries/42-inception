FROM debian:bullseye

# update
RUN apt update
RUN apt upgrade -y
RUN apt autoremove --yes
RUN apt clean autoclean

# install php and wordpress
RUN apt install -y php7.4
RUN apt install -y php-fpm
RUN apt install -y php-mysql
RUN apt install -y mariadb-client
# wordpress
RUN apt install -y wget
RUN wget https://wordpress.org/wordpress-6.3.2.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.3.2.tar.gz && rm wordpress-6.3.2.tar.gz
RUN chown -R root:root /var/www/wordpress

# configuring php
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# installing a cli for wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

ARG SQL_DATABASE_NAME
ARG SQL_USER_NAME
ARG SQL_USER_PASSWORD
ARG WORDPRESS_ADMIN_USERNAME
ARG WORDPRESS_ADMIN_PASSWORD
ARG WORDPRESS_ADMIN_EMAIL
ARG WORDPRESS_USER_NAME
ARG WORDPRESS_USER_EMAIL

# configuring wordpress
RUN if [ ! -f "/var/www/wordpress/wp-config.php" ]; then \
        while ! mysqladmin ping -h"$SQL_DATABASE_NAME" --silent; do \
              sleep 1;\
        done; \
        wp config create --allow-root \
                         --dbname="$SQL_DATABASE_NAME" \
                         --dbuser="$SQL_USER_NAME" \
                         --dbpass="$SQL_USER_PASSWORD" \
                         --dbhost="mariadb:3306" \
                         --path="/var/www/wordpress"; \
        wp core install --allow-root \
                        --url="vfries.42.fr" \
                        --title="Inception" \
                        --admin_user="$WORDPRESS_ADMIN_USERNAME" \
                        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
                        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
                        --path="/var/www/wordpress"; \
        wp user create $WORDPRESS_USER_NAME $WORDPRESS_USER_EMAIL --allow-root \
                                                                  --path="/var/www/wordpress"; \
    fi

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
