package main

import (
    "crypto/tls"
    "fmt"
    "io/ioutil"
    "log"
    "net/http"
    "os"
)

func main() {
    // إعداد العميل لتجاوز التحقق من الشهادات (للتجربة فقط)
    http.DefaultTransport = &http.Transport{
        TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
    }

    // الحصول على الرابط من متغير البيئة
    m3uURL := os.Getenv("M3U_URL")
    if m3uURL == "" {
        log.Fatal("Environment variable M3U_URL is not set")
    }

    // طلب الملف من الرابط
    response, err := http.Get(m3uURL)
    if err != nil {
        log.Fatalf("Failed to fetch M3U file: %v", err)
    }
    defer response.Body.Close()

    // قراءة محتويات الملف
    content, err := ioutil.ReadAll(response.Body)
    if err != nil {
        log.Fatalf("Failed to read M3U file content: %v", err)
    }

    // طباعة المحتويات (يمكنك تغيير هذا الجزء للمعالجة كما تحتاج)
    fmt.Println(string(content))
}
