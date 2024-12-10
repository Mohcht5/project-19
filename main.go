package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"
)

// قراءة ملف M3U من الرابط
func fetchM3U(m3uURL string) ([]string, error) {
	resp, err := http.Get(m3uURL)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("failed to fetch M3U file: %s", resp.Status)
	}

	var urls []string
	scanner := bufio.NewScanner(resp.Body)
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "http") { // استخراج الروابط فقط
			urls = append(urls, line)
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return urls, nil
}

// معالجة الطلبات عبر Proxy
func proxyHandler(targetURL string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get(targetURL)
		if err != nil {
			http.Error(w, "Failed to fetch the stream", http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		// تمرير البيانات للعميل
		w.Header().Set("Content-Type", "application/vnd.apple.mpegurl")
		_, err = bufio.NewReader(resp.Body).WriteTo(w)
		if err != nil {
			http.Error(w, "Failed to write response", http.StatusInternalServerError)
		}
	}
}

func main() {
	// قراءة رابط ملف القنوات من متغير البيئة
	m3uURL := os.Getenv("M3U_URL")
	if m3uURL == "" {
		log.Fatal("M3U_URL environment variable is not set")
	}

	// التحقق من صحة الرابط
	_, err := url.ParseRequestURI(m3uURL)
	if err != nil {
		log.Fatalf("Invalid M3U URL: %v", err)
	}

	// جلب روابط القنوات
	urls, err := fetchM3U(m3uURL)
	if err != nil {
		log.Fatalf("Failed to fetch M3U file: %v", err)
	}

	if len(urls) == 0 {
		log.Fatalf("No URLs found in the M3U file")
	}

	port := "8080"

	// إعداد خادم لكل رابط
	for i, url := range urls {
		http.HandleFunc(fmt.Sprintf("/stream/%d", i), proxyHandler(url))
		log.Printf("Stream available at: http://localhost:%s/stream/%d\n", port, i)
	}

	// تشغيل الخادم
	log.Printf("Server started at port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

