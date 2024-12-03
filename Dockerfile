# استخدام صورة Ubuntu LTS (مثال: 20.04)
FROM ubuntu:20.04

# تحديث الحزم وتثبيت الأساسيات
RUN apt-get update && apt-get upgrade -y

# تثبيت الحزم التي قد تحتاجها
RUN apt-get install -y \
    curl \
    wget \
    vim \
    net-tools \
    git

# تعيين البيئة بشكل اختياري
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# تنفيذ أي أوامر إضافية هنا حسب الحاجة
# مثل تثبيت تطبيقات أو خدمات أخرى

# تعيين المنفذ الذي سيتم تعريضه (اختياري)
EXPOSE 80 443

# تحديد الأمر الافتراضي الذي سيتم تنفيذه عند تشغيل الحاوية
CMD ["bash"]
