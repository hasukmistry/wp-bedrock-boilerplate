FROM php:8.0-fpm

LABEL maintainer="Hasmukh Mistry <hasmukhmistry137@gmail.com>"
LABEL description="Dockerised Wordpress Application"

RUN apt-get update -y

# Essentials
RUN apt-get -y install build-essential curl gnupg lsb-release gcc make autoconf libc-dev pkg-config

RUN apt-get install -y --no-install-recommends \
    libmagick++-dev \
    libmagickcore-dev libmagickwand-dev \
    freetds-bin freetds-dev freetds-common libsybdb5 libpq-dev \
    libzip-dev \
    libgd-dev libpng++-dev libwebp-dev libjpeg-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libvpx-dev libfreetype6-dev \
    libmcrypt-dev \
    libssh2-1-dev \
    ghostscript

# fix for docker-php-ext-install pdo_dblib
# https://stackoverflow.com/questions/43617752/docker-php-and-freetds-cannot-find-freetds-in-know-installation-directories
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/

# https://make.wordpress.org/hosting/handbook/handbook/server-environment/
RUN docker-php-ext-install exif
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_dblib pdo_mysql pdo_pgsql
RUN docker-php-ext-install zip
RUN docker-php-ext-install bcmath

# install GD
RUN docker-php-ext-configure gd \
	--with-jpeg \
	--with-xpm \
	--with-webp \
	--with-freetype \
	&& docker-php-ext-install -j$(nproc) gd

# install pecl extension
RUN pecl install imagick && \
	docker-php-ext-enable imagick

RUN docker-php-ext-install intl

RUN apt-get update && apt-get install -y mariadb-client && rm -rf /var/lib/apt

# Install xdebug extension
RUN pecl install xdebug && docker-php-ext-enable xdebug

# install APCu
RUN pecl install apcu && docker-php-ext-enable apcu --ini-name docker-php-ext-10-apcu.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash && \
    chmod +x wp-completion.bash && \
    mv wp-completion.bash /usr/local/src/wp-completion.bash

# Install supervisor
RUN apt-get update -y && apt-get install -y --no-install-recommends supervisor

# Clean up
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add configuration files
ADD docker/config/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/
ADD docker/config/php/php.ini /usr/local/etc/php/

# Set default work directory
COPY scripts/ /usr/local/bin/
RUN chmod +x -R /usr/local/bin/*

# Composer & log directory tweaks
ARG COMPOSER_HOME=/var/www/.composer
ARG WEB_USER=www-data
ARG WP_DEBUG_LOG=/var/www/logs

RUN mkdir $COMPOSER_HOME && chown -R $WEB_USER:$WEB_USER $COMPOSER_HOME
RUN mkdir $WP_DEBUG_LOG && chown -R $WEB_USER:$WEB_USER $WP_DEBUG_LOG

USER $WEB_USER

WORKDIR /var/www/html