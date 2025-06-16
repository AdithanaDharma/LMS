FROM php:8.4-apache

# Install system dependencies dan PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    libssl-dev \
    libxslt1-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    libmariadb-dev \
    libmariadb-dev-compat \
    git \
    unzip \
    mariadb-client \
    vim \
    curl \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    gd \
    mysqli \
    zip \
    intl \
    soap \
    exif \
    opcache \
    pdo_mysql \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Aktifkan mod_rewrite
RUN a2enmod rewrite

# Copy konfigurasi PHP
COPY moodle-php.ini /usr/local/etc/php/conf.d/moodle.ini

# Copy source Moodle (pastikan file .dockerignore diatur jika tidak ingin semua folder lokal ikut)
COPY . /var/www/html/

# Pastikan direktori tidak bertumpuk hasil COPY (pastikan source moodle bukan di root context)
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Buat moodledata (sebaiknya dari luar pakai volume, tapi bisa disiapkan untuk testing lokal)
RUN mkdir -p /var/www/moodledata \
 && chown -R www-data:www-data /var/www/moodledata \
 && chmod -R 755 /var/www/moodledata

EXPOSE 80
