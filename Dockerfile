FROM php:7.1-fpm
MAINTAINER David Perez <davidpv@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

#Workdir
WORKDIR "/var/www"

#APT-GET
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip
    build-essential \
    libssl-dev \
    git \
    jpegoptim \
    libicu-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libgd-dev \
    libmcrypt-dev \
    rubygems

#PHP Extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr \
    && docker-php-ext-install \
        opcache \
        intl \
        pcntl \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        gd \
        mcrypt \
        bcmath \
        json \
        bcmath \
        exif

#MEMCACHE
RUN cd /tmp/ \
    && wget https://github.com/php-memcached-dev/php-memcached/archive/php7.zip -O php-memcached-php7.zip \
    && unzip -o php-memcached-php7.zip \
    && cd php-memcached-php7 \
    && phpize \
    && ./configure --disable-memcached-sasl \
    && make && make install

RUN cd /tmp/ \
    && rm -rf pecl-memcache \
    && git clone https://github.com/websupport-sk/pecl-memcache.git \
    && cd pecl-memcache && phpize \
    && ./configure --disable-memcache-sasl \
    && make && make install
    
RUN echo 'error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE & ~E_WARNING' >> /usr/local/etc/php/conf.d/custom.ini
RUN echo 'extension=memcache.so' >> /usr/local/etc/php/conf.d/custom.ini


#install de symfony installer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

#Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin \
    && php -r "unlink('composer-setup.php');"

#Install capifony
RUN gem install capifony

# PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Symfony's fix permissions
RUN usermod -u 1000 www-data

#Locale
#COPY locale.gen /etc/
#RUN apt-get update
#RUN echo "LC_ALL=es_ES.UTF-8" >> /etc/default/locale
#RUN export LC_ALL="es_ES.UTF-8"
#RUN dpkg-reconfigure locales
#RUN apt-get install locales

# Cleanup
RUN apt-get autoremove -y && apt-get clean all

#expose
EXPOSE 9000
