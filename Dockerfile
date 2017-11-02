FROM php:7.1-fpm
MAINTAINER David Perez <davidpv@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

#APT-GET
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    build-essential \
    libssl-dev \
    git \
    sudo \
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
        sockets \
        exif

#SOCKETS
RUN docker-php-ext-install sockets

#MEMCACHE
#RUN cd /tmp/ \
#    && wget https://github.com/php-memcached-dev/php-memcached/archive/php7.zip -O php-memcached-php7.zip \
#    && unzip -o php-memcached-php7.zip \
#    && cd php-memcached-php7 \
#    && phpize \
#    && ./configure --disable-memcached-sasl \
#    && make && make install

RUN cd /tmp/ \
    && rm -rf pecl-memcache \
    && git clone https://github.com/websupport-sk/pecl-memcache.git \
    && cd pecl-memcache && phpize \
    && ./configure --disable-memcache-sasl \
    && echo "docker" | sudo -S make && echo "docker" | sudo -S make install
RUN echo 'error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE & ~E_WARNING' >> /usr/local/etc/php/conf.d/custom.ini
RUN echo 'extension=memcache.so' >> /usr/local/etc/php/conf.d/custom.ini

#MONGO
RUN pecl install -f mongodb
RUN echo 'extension=mongodb.so' >> /usr/local/etc/php/conf.d/custom.ini

#install de symfony installer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

#Composer && hirak/prestissimo
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin \
    && php -r "unlink('composer-setup.php');" \
    && /usr/local/bin/composer.phar global require hirak/prestissimo

#Install capifony
RUN gem install capifony

# PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

#install node
RUN echo 'export PATH=$PATH:/usr/local/bin' >> $HOME/.bashrc
RUN apt-get update && apt-get install -y curl gnupg2 && curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs

# Symfony's fix permissions
RUN usermod -u 1000 www-data

# Cleanup
RUN apt-get autoremove -y && apt-get clean all

#USERADD
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
WORKDIR /home/docker/www/project
USER docker

#expose
EXPOSE 9000
