# استخدام صورة Ubuntu كأساس
FROM ubuntu:20.04

# إعداد البيئة (تحديث الحزم وتثبيت الحزم الأساسية مثل curl, wget, git, etc.)
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y wget curl git sudo \
    apache2 php libapache2-mod-php mysql-server \
    php-mysql php-xml php-curl php-mbstring \
    php-zip php-json

# تنزيل السكربت
RUN wget https://raw.githubusercontent.com/iptvpanel/Xtream-Codes-1.60.0/master/installer.sh -O /installer.sh

# إعطاء صلاحيات تنفيذ السكربت
RUN chmod 755 /installer.sh

# تنفيذ السكربت
RUN /bin/bash /installer.sh

# فتح المنفذ 80 لتشغيل Apache
EXPOSE 80

# بدء Apache عند تشغيل الحاوية
CMD ["apachectl", "-D", "FOREGROUND"]
