# استخدام صورة Ubuntu كأساس
FROM ubuntu:20.04

# تثبيت الحزم المطلوبة
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xrdp \
    supervisor \
    dbus-x11 \
    && apt-get clean

# إعداد xRDP لبدء التشغيل
RUN echo "startxfce4" > ~/.xsession

# فتح المنفذ الخاص بـ RDP (عادة 3389)
EXPOSE 3389

# بدء xRDP باستخدام supervisord
CMD ["/usr/bin/supervisord"]
