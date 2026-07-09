/// Shared input validation for client-side guards (server rules are authoritative).
class InputValidators {
  InputValidators._();

  static const maxNameLength = 100;
  static const maxPhoneLength = 20;
  static const maxAddressLength = 300;
  static const maxCityLength = 80;
  static const maxZipLength = 12;
  static const maxSearchLength = 80;
  static const maxProductIdLength = 64;

  static final _controlChars = RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]');
  static final _productIdPattern = RegExp(r'^[a-zA-Z0-9_-]+$');

  static String? sanitizeText(
    String? value, {
    required String fieldName,
    int maxLength = 200,
    bool required = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return required ? '$fieldName is required.' : null;
    }
    final trimmed = value.trim();
    if (trimmed.length > maxLength) {
      return '$fieldName must be at most $maxLength characters.';
    }
    if (_controlChars.hasMatch(trimmed)) {
      return '$fieldName contains invalid characters.';
    }
    return null;
  }

  static String? validateName(String? value) =>
      sanitizeText(value, fieldName: 'Name', maxLength: maxNameLength);

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (trimmed.length > maxPhoneLength) {
      return 'Phone must be at most $maxPhoneLength characters.';
    }
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(trimmed)) {
      return 'Phone contains invalid characters.';
    }
    return null;
  }

  static String? validateSearchQuery(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > maxSearchLength) {
      return 'Search query is too long.';
    }
    if (_controlChars.hasMatch(value)) {
      return 'Search query contains invalid characters.';
    }
    return null;
  }

  static String? validateProductId(String? id) {
    if (id == null || id.isEmpty) return 'Invalid product.';
    if (id.length > maxProductIdLength) return 'Invalid product.';
    if (!_productIdPattern.hasMatch(id)) return 'Invalid product.';
    return null;
  }

  static String clampSearchQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.length <= maxSearchLength) return trimmed;
    return trimmed.substring(0, maxSearchLength);
  }
}
