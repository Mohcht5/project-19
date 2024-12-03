# استخدام صورة PHP مع Apache ونسخة أحدث من PHP 8.0 أو 8.1
FROM php:8.1-apache

# تحديث المستودعات
RUN apt-get update --fix-missing && apt-get upgrade -y

# تثبيت الحزم الضرورية (وإزالة الحزم التي لم تعد ضرورية بعد التثبيت)
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

# تثبيت Composer إذا لزم الأمر (لتثبيت تبعيات Xtreme UI)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer install --no-dev --optimize-autoloader

# تعيين صلاحيات المجلدات والملفات
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# تعريض المنفذ 80 (لاستقبال الاتصال)
EXPOSE 80

# بدء Apache في الوضع الأمامي
CMD ["apache2-foreground"]
