FROM debian:bullseye

# update
RUN apt update
RUN apt upgrade -y
RUN apt autoremove --yes
RUN apt clean autoclean

# nginx
RUN apt install -y nginx

# tsl
RUN mkdir -p /etc/nginx/ssl
RUN apt install -y openssl
RUN openssl req -x509 \
                -nodes \
                -out /etc/nginx/ssl/ssl_certificate.crt \
                -keyout /etc/nginx/ssl/ssl_certificate_key.key \
                -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=vfries.42.fr/UID=vfries"

# nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx"]
