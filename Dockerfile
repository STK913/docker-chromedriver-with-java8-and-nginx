FROM openjdk:8-jre
LABEL maintainer="hello@ubimap.fr"

ENV NGINX_VERSION 1.10.3-1~jessie
RUN apt-key update && apt-get update
RUN apt-get install apt-transport-https libcurl3-gnutls
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list
RUN echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update && apt-get install --allow-unauthenticated --no-install-recommends --no-install-suggests -y \
	ca-certificates \
	nginx=${NGINX_VERSION} \
	nginx-module-xslt \
	nginx-module-geoip \
	nginx-module-image-filter \
	nginx-module-perl \
	nginx-module-njs \
	gettext-base \
	chromedriver \
	google-chrome-stable

RUN apt-get -f install -y
RUN rm -rf /var/lib/apt/lists/*
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]