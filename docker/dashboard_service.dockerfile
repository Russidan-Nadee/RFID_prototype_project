FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

# RUN dart compile exe lib/services/dashboard_service/main.dart -o dashboard_service

EXPOSE 8003

CMD ["dart", "lib/services/dashboard_service/main.dart"]