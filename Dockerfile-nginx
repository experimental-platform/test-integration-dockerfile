FROM experimentalplatform/ubuntu:latest

RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD index.html /var/www/html/index.html

CMD ["nginx"]

EXPOSE 80
EXPOSE 443