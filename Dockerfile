FROM php:8.4-apache

# Install required system packages dan PHP extensions
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
    curl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install \
        gd \
        mysqli \
        zip \
        intl \
        soap \
        exif \
        opcache \
        pdo_mysql && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Aktifkan mod_rewrite untuk Moodle
RUN a2enmod rewrite

# Tambahkan pengaturan PHP agar sesuai dengan kebutuhan Moodle
COPY moodle-php.ini /usr/local/etc/php/conf.d/moodle.ini

# Copy Moodle source ke dalam container
COPY . /var/www/html/

# Set permission Moodle
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Buat direktori moodledata dengan permission yang tepat
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 755 /var/www/moodledata

EXPOSE 80
