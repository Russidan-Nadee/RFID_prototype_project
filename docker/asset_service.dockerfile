FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

# RUN dart compile exe lib/services/asset_service/main.dart -o asset_service

EXPOSE 8001

CMD ["dart", "lib/services/asset_service/main.dart"]