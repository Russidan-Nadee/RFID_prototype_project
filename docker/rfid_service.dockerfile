FROM ubuntu:22.04

WORKDIR /app

COPY . .

# ไม่มีการติดตั้ง Flutter หรือดาวน์โหลดอะไรเพิ่มเติม
# คิดว่า Flutter อาจถูกติดตั้งในโปรเจคแล้ว

EXPOSE 8002

# ถ้าเป็นไปได้ ใช้เครื่องมือที่มีอยู่ในโปรเจค
CMD ["bash", "-c", "if [ -f /app/flutter/bin/dart ]; then /app/flutter/bin/dart lib/services/rfid_service/main.dart; else dart lib/services/rfid_service/main.dart; fi"]