# Use the official PHP image with Apache as the base image
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Install dependencies required for Composer and Laravel
RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y \
    nano \
    wget \
    git \
    curl \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libzip-dev \
    locales \
    libmcrypt-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev

RUN docker-php-ext-install \
    exif \
    pcntl \
    bcmath \
    ctype \
    curl \
    mbstring \
    iconv \
    xml \
    soap \
    zip \
    intl

# Download and install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up the environment variable to prevent Composer from asking for interactive questions
ENV COMPOSER_HOME /composer

# Set the PATH to include Composer executable
ENV PATH $PATH:/composer/vendor/bin

# Copy the Apache VirtualHost configuration
COPY apache/apache-config/laravel.conf /etc/apache2/sites-available/

# Enable the VirtualHost
RUN a2ensite laravel.conf && a2dissite 000-default

# Enable mod_rewrite
RUN a2enmod rewrite

# Copy the Laravel application files
COPY webs/laravel-starter . /var/www/html
COPY webs/laravel-starter/composer.json /var/www/html/
COPY webs/laravel-starter/composer.lock /var/www/html/
COPY webs/laravel-starter/.env /var/www/html/
# Copy composer files and install dependencies
RUN composer install 

# Generate key, migrate database, dan jalankan seeder saat container berjalan
CMD php artisan key:generate && php artisan migrate && php artisan db:seed && php artisan starter:insert-demo-data --fresh

# Set file permissions
RUN mkdir -p /var/www/html/storage && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/storage

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
