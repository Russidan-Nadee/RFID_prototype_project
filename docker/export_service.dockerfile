FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

# สร้างโฟลเดอร์สำหรับเก็บไฟล์ส่งออก
RUN mkdir -p /app/exports

COPY . .

RUN flutter pub get

# RUN dart compile exe lib/services/export_service/main.dart -o export_service

# กำหนดสิทธิ์การเข้าถึงโฟลเดอร์ exports
RUN chmod -R 777 /app/exports

EXPOSE 8004

CMD ["dart", "lib/services/export_service/main.dart"] 