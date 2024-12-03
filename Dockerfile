# استخدام صورة PHP مع Apache كقاعدة
FROM php:7.4-apache

# تحديث مستودعات الحزم
RUN apt-get update --fix-missing

# تثبيت الحزم الضرورية
RUN apt-get install -y \
    libapache2-mod-php \
    git \
    unzip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# تمكين mod_rewrite
RUN a2enmod rewrite

# إعداد مجلد العمل داخل الحاوية
WORKDIR /var/www/html

# نسخ ملفات Xtreme UI إلى مجلد العمل
COPY . /var/www/html/

# تثبيت التبعيات عبر Composer (إذا كان Xtreme UI يستخدم Composer)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer install --no-dev --optimize-autoloader

# تعيين صلاحيات المجلدات (إذا لزم الأمر)
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# تعريض المنفذ الذي يعمل عليه التطبيق
EXPOSE 80

# تنفيذ Apache في الوضع الأمامي
CMD ["apache2-foreground"]
