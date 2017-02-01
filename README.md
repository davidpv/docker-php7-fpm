# docker-php7-fpm
Docker php7-fpm ready with default modules to run a Symfony3 app.

##modules installed
* PHPUnit
* Composer
* docker-php-ext-install
* opcache
* intl
* pcntl
* mbstring
* mysqli
* pdo
* pdo_mysql
* zip
* gd
* mcrypt
* json
* exif

##Usage example

```
docker run -it \
    -v ~/my_php.ini:/usr/local/etc/php/conf.d/custom.ini \
    -v ~/project_files/:/var/www/symfony" \
    davidpv/docker-php7-fpm
```

Inside de container:

1. `symfony new symfony`
2. `cd symfony`
3. `composer.phar install`

