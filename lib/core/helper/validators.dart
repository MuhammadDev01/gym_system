class Validators {
  Validators._();

  static String? requiredField(
    String? value, {
    String message = 'هذا الحقل مطلوب',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(
    String? value, {
    String message = 'Enter a valid email',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    final pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$";
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value.trim())) return message;
    return null;
  }

  static String? password(String? value, {int minLength = 6, String? message}) {
    final m = message ?? 'Password must be at least $minLength characters';
    if (value == null || value.isEmpty) return m;
    if (value.length < minLength) return m;
    return null;
  }

  static String? confirmPassword(
    String? value,
    String? original, {
    String message = 'Passwords do not match',
  }) {
    if (value == null || original == null) return message;
    if (value != original) return message;
    return null;
  }

  static String? phone(
    String? value, {
    String message = 'Enter a valid phone number',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    final pattern = r"^\+?[0-9]{7,15}\$";
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value.trim())) return message;
    return null;
  }

  static String? numeric(
    String? value, {
    String message = 'Enter a valid number',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    final num? parsed = num.tryParse(value);
    if (parsed == null) return message;
    return null;
  }
}
