# استخدام صورة Go الرسمية
FROM golang:1.21 as builder

# إعداد العمل داخل الحاوية
WORKDIR /app

# نسخ الملفات
COPY . .

# بناء التطبيق
RUN go build -o m3u-proxy

# استخدام صورة خفيفة للتشغيل
FROM debian:bullseye-slim

# نسخ الملف التنفيذي من المرحلة الأولى
COPY --from=builder /app/m3u-proxy /app/m3u-proxy

# إعداد العمل داخل الحاوية
WORKDIR /app

# تحديد المنفذ
EXPOSE 8080

# تحديد المتغيرات البيئية الافتراضية (اختياري)
ENV M3U_URL=""

# تشغيل التطبيق
CMD ["./m3u-proxy"]
