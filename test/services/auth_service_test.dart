import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wordpress2/src/services/auth_service.dart';

void main() {
  group('AuthService', () {
    test('should be created successfully', () {
      final authService = AuthService();
      expect(authService, isNotNull);
    });
  });
}
