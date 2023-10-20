FROM debian:buster

RUN apt update
RUN apt upgrade -y
RUN apt autoremove --yes
RUN apt clean autoclean

RUN apt install -y wget
RUN apt install -y php7.3
RUN apt install -y php-fpm
RUN apt install -y php-mysql
RUN apt install -y mariadb-client

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

RUN wget https://github.com/wp-cli/wp-cli-bundle/releases/download/v2.7.0/wp-cli-2.7.0.phar
RUN mv wp-cli-2.7.0.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

COPY tools/startup_task.sh /tools/startup_task.sh

RUN chmod +x /tools/startup_task.sh

CMD ["/tools/startup_task.sh"]

EXPOSE 9000
EXPOSE 3306
