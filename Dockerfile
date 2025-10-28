FROM composer:2 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-scripts --no-progress

FROM php:8.2-fpm-alpine

RUN apk update --no-cache \
    php8-pdo \
    php8-mbstring \
    php8-openssl \
    php8-tokenizer \
    php8-json \
    php8-xml \
    php8-curl \
    php8-mysqlnd \
    php8-bcmath \
    php8-fileinfo \
    bash \
    nginx \
    supervisor \
    curl

WORKDIR /var/www

COPY . .
COPY --from=vendor /app/vendor ./vendor

RUN chown -R www-data:www-data /var/www && chmod -R 775 /var/www
EXPOSE 8888

CMD php artisan serve --host=0.0.0.0 --port=80
