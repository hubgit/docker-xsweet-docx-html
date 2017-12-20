FROM hubdock/docker-php7-apache-saxonhe

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y --no-install-recommends libzip-dev \
    && docker-php-ext-install -j$(nproc) zip \
    && rm -rf /var/lib/apt/lists/

COPY src/ /var/www/html/

RUN mkdir /input
VOLUME /input
