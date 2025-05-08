FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

# RUN dart compile exe lib/services/api_gateway/main.dart -o api_gateway

EXPOSE 8000

CMD ["dart", "lib/services/api_gateway/main.dart"]