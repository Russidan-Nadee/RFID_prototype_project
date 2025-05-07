class ValidationUtils {
  static String? validateRequired(
    String? value, {
    String message = 'จำเป็นต้องกรอกข้อมูลนี้',
  }) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอกอีเมลให้ถูกต้อง';
    }
    return null;
  }

  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (value.length < minLength) {
      return 'รหัสผ่านต้องมีความยาวอย่างน้อย $minLength ตัวอักษร';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกเบอร์โทรศัพท์';
    }
    final mobileRegex = RegExp(r'^[0-9]{10}$');
    if (!mobileRegex.hasMatch(value)) {
      return 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง';
    }
    return null;
  }

  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String? fieldName,
  }) {
    if (value != null && value.length > maxLength) {
      final name = fieldName != null ? '$fieldName ' : '';
      return '$nameต้องมีความยาวไม่เกิน $maxLength ตัวอักษร';
    }
    return null;
  }

  static String? validateUid(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก UID';
    }
    if (value.length != 10) {
      return 'UID ต้องมีความยาว 10 ตัวอักษร';
    }
    return null;
  }
}
