class AppException implements Exception {
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

class DatabaseException extends AppException {
  DatabaseException([String? message])
    : super(message ?? "Database Error", "DatabaseException: ");
}

class AssetNotFoundException extends AppException {
  AssetNotFoundException([String? message])
    : super(message ?? "Asset Not Found", "AssetNotFoundException: ");
}
