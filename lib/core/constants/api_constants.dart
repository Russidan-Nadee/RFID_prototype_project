class ApiConstants {
  // API Endpoints
  static const String assets = '/assets';
  static const String categories = '/categories';
  static const String departments = '/departments';
  static const String rfid = '/rfid';
  static const String dashboard = '/dashboard';
  static const String export = '/export';

  // HTTP Status Codes
  static const int ok = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int notFound = 404;
  static const int internalServerError = 500;

  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';

  // Timeout values (milliseconds)
  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 10000;
}
