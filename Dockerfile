# المرحلة الأولى: بناء التطبيق
FROM golang:1.21 as builder

WORKDIR /app

COPY . .

RUN go mod tidy
RUN go build -o m3u-proxy

# المرحلة الثانية: التشغيل
FROM ubuntu:22.04

WORKDIR /app

# تثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    libc6 \
    && apt-get clean

# نسخ التطبيق
COPY --from=builder /app/m3u-proxy /app/m3u-proxy

EXPOSE 8080

ENV M3U_URL=""

CMD ["./m3u-proxy"]
