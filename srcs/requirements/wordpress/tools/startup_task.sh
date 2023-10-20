#! /bin/bash

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    sleep 10 # Find another way to wait for mariadb to be ready

    >&2 echo Downloading wordpress
    wp core download --allow-root \
                     --path=/var/www/wordpress \
        || (>&2 echo Error downloading wordpress; exit 1)

    >&2 echo Configuring wordpress
    wp config create --allow-root \
                     --dbname=$SQL_DATABASE_NAME \
                     --dbuser=$SQL_USER_NAME \
                     --dbpass=$SQL_USER_PASSWORD \
                     --dbhost=mariadb:3306 \
                     --path=/var/www/wordpress \
        || (>&2 echo Error creating wordpress config; exit 2)

    >&2 echo Installing wordpress core
    wp core install --allow-root \
                    --url="vfries.42.fr" \
                    --title="Inception" \
                    --admin_user="$WORDPRESS_ADMIN_USERNAME" \
                    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
                    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
                    --path=/var/www/wordpress \
        || (>&2 echo Error installing wordpress core; exit 3)

    >&2 echo Creating new wordpress user
    wp user create $WORDPRESS_USER_NAME $WORDPRESS_USER_EMAIL --allow-root \
                                                              --path=/var/www/wordpress \
        || (>&2 echo Error creating new wordpress user; exit 4)

    >&2 echo Successfully installed wordpress
else
    >&2 echo Wordpress already installed
fi

mkdir -p /run/php
php-fpm7.3 -F || (>&2 echo Error running php-fpm; exit 5)
