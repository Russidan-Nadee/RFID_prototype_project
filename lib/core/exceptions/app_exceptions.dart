abstract class AppException implements Exception {
  final String message;
  final String? prefix;
  final String? url;

  AppException([this.message = '', this.prefix, this.url]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
    : super(
        message ?? "Error During Communication",
        "FetchDataException: ",
        url,
      );
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
    : super(message ?? "Invalid Request", "BadRequestException: ", url);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message, String? url])
    : super(message ?? "Unauthorized", "UnauthorizedException: ", url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
    : super(message ?? "Not Found", "NotFoundException: ", url);
}

class DatabaseException extends AppException {
  DatabaseException([String? message])
    : super(message ?? "Database Error", "DatabaseException: ");
}

class AssetNotFoundException extends AppException {
  AssetNotFoundException([String? message])
    : super(message ?? "Asset Not Found", "AssetNotFoundException: ");
}

class RfidException extends AppException {
  RfidException([String? message])
    : super(message ?? "RFID Error", "RfidException: ");
}
