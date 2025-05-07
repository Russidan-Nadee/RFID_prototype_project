class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data:
          json['data'] != null && fromJson != null
              ? fromJson(json['data'])
              : null,
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson([Map<String, dynamic> Function(T)? toJsonT]) {
    final Map<String, dynamic> json = {'success': success, 'message': message};

    if (statusCode != null) {
      json['statusCode'] = statusCode;
    }

    if (data != null && toJsonT != null) {
      json['data'] = toJsonT(data as T);
    } else if (data != null) {
      try {
        final dataMap = data as Map<String, dynamic>?;
        if (dataMap != null) {
          json['data'] = dataMap;
        }
      } catch (e) {
        // ถ้าไม่สามารถแปลง data เป็น Map<String, dynamic> ได้
        // ให้ข้ามการเพิ่ม data เข้าไปใน json
      }
    }

    return json;
  }

  factory ApiResponse.success({T? data, String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message ?? 'ดำเนินการสำเร็จ',
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.error({String? message, int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message ?? 'เกิดข้อผิดพลาด',
      statusCode: statusCode ?? 500,
    );
  }

  ApiResponse<R> map<R>(R Function(T?) mapper) {
    return ApiResponse<R>(
      success: success,
      message: message,
      statusCode: statusCode,
      data: mapper(data),
    );
  }

  @override
  String toString() {
    return 'ApiResponse{success: $success, message: $message, statusCode: $statusCode, data: $data}';
  }
}
