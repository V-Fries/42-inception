FROM debian:bullseye

# update
RUN apt update
RUN apt upgrade -y
RUN apt autoremove --yes
RUN apt clean autoclean

# mariadb
RUN apt install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ARG SQL_DATABASE_NAME
ARG SQL_USER_NAME
ARG SQL_USER_PASSWORD
ARG SQL_ROOT_PASSWORD

RUN service mariadb start \
    && mysql -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE_NAME; \
                 CREATE USER IF NOT EXISTS $SQL_USER_NAME@'localhost' IDENTIFIED BY '$SQL_USER_PASSWORD'; \
                 GRANT ALL PRIVILEGES ON $SQL_DATABASE_NAME.* TO $SQL_USER_NAME@'%' IDENTIFIED BY '$SQL_USER_PASSWORD'; \
                 ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD'; \
                 FLUSH PRIVILEGES;" \
    && mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

EXPOSE 3306

CMD ["mysqld"]
