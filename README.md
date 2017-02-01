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
    -v ~/project_files/:/var/www/project" \
    -p 8000:8000 \
    davidpv/docker-php7-fpm
```

Inside de container:

1. `cd project`
2. `symfony new .`
3. `composer.phar install`
4. `php bin/console server:run`
4. `http://localhost:8000`

