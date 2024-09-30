# Use the official PHP image as the base image
FROM php:8.0-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd mbstring exif pcntl bcmath xml

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

# Set environment variable to allow Composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev --ignore-platform-req=ext-zip

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Ensure Apache can access the project files
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Copy custom Apache configuration
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable the new configuration
RUN a2ensite 000-default.conf



# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
