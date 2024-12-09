# استخدام صورة أساسية تحتوي على Bash و الأدوات المطلوبة
FROM debian:bullseye-slim

# تثبيت الأدوات الأساسية مثل wget و sed و mysql-client
RUN apt-get update && apt-get install -y \
    wget \
    sed \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

# تحميل السكربتات من GitHub
RUN wget https://github.com/IPTVUNION/iptvunion/raw/refs/heads/master/iptvunion.sh -O /usr/local/bin/iptvunion.sh \
    && wget https://github.com/IPTVUNION/iptvunion/raw/refs/heads/master/iptvunionWeb.sh -O /usr/local/bin/iptvunionWeb.sh

# إعطاء أذونات التنفيذ للسكريبتات
RUN chmod +x /usr/local/bin/iptvunion.sh /usr/local/bin/iptvunionWeb.sh

# تعيين السكربت الذي سيتم تنفيذه عند بدء تشغيل الحاوية
ENTRYPOINT ["/usr/local/bin/iptvunion.sh"]
