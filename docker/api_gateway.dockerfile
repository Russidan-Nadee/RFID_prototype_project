FROM ubuntu:22.04

# ตั้งค่าสภาพแวดล้อม
ENV DEBIAN_FRONTEND=noninteractive

# ติดตั้งเครื่องมือพื้นฐาน
RUN apt-get update && apt-get install -y \
   curl \
   git \
   unzip \
   && rm -rf /var/lib/apt/lists/*

# ติดตั้ง Dart SDK
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN curl -fsSL https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list
RUN apt-get update && apt-get install -y dart

# เพิ่ม Dart SDK ลงใน PATH
ENV PATH="$PATH:/usr/lib/dart/bin:/root/.pub-cache/bin"

# สร้างโฟลเดอร์สำหรับแอป
WORKDIR /app

# คัดลอกโค้ดโปรเจค
COPY . .

# เริ่มต้นติดตั้ง dependencies
RUN dart pub get

# คอมไพล์แอป
RUN dart compile exe lib/services/api_gateway/main.dart -o api_gateway

# เปิดพอร์ต
EXPOSE 8000

# รันแอป
CMD ["./api_gateway"]