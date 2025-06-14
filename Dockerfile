FROM php:8.4-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl mariadb-client \
    && docker-php-ext-install mysqli zip

# Aktifkan mod_rewrite untuk Moodle
RUN a2enmod rewrite

# Copy Moodle files ke Apache root
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Buat direktori moodledata dengan permission yang tepat
RUN mkdir /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 755 /var/www/moodledata

# Expose port
EXPOSE 80
