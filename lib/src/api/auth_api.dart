import 'package:dio/dio.dart';
import '../models/auth_models.dart';
import 'magento_api_client.dart';

/// Authentication API for Magento integration.
///
/// This class provides comprehensive authentication functionality for Magento,
/// including customer login, registration, password management, and social authentication.
///
/// ## Features
///
/// - **Customer Login**: Authenticate with email and password
/// - **Customer Registration**: Create new customer accounts
/// - **Password Management**: Change passwords and reset forgotten passwords
/// - **Social Login**: Support for social media authentication
/// - **Token Management**: Automatic token storage and refresh
/// - **Session Management**: Login/logout functionality
///
/// ## Usage
///
/// ```dart
/// final authApi = AuthApi(apiClient);
///
/// // Login customer
/// final response = await authApi.login(
///   email: 'customer@example.com',
///   password: 'password123',
/// );
///
/// // Register new customer
/// final customer = await authApi.register(
///   request: CustomerCreateRequest(...),
/// );
/// ```
class AuthApi {
  final MagentoApiClient _client;

  AuthApi(this._client);

  /// Authenticate customer with email and password.
  ///
  /// Attempts to log in a customer using their email and password credentials.
  /// Upon successful authentication, the customer token is automatically stored
  /// for subsequent authenticated requests.
  ///
  /// [email] the customer's email address
  /// [password] the customer's password
  ///
  /// Returns an [AuthResponse] containing the authentication token and customer data.
  /// Throws an exception if authentication fails.
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.guestRequest<Map<String, dynamic>>(
        '/rest/V1/integration/customer/token',
        data: {'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // Store tokens
        await _client.storeTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          customerId: authResponse.customer.id,
        );

        return authResponse;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      }
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register a new customer account.
  ///
  /// Creates a new customer account in the Magento system with the provided information.
  /// The customer will need to authenticate separately after registration.
  ///
  /// [request] the customer registration request containing all required fields
  ///
  /// Returns a [Customer] object representing the newly created customer.
  /// Throws an exception if registration fails.
  Future<Customer> register({required CustomerCreateRequest request}) async {
    try {
      final response = await _client.guestRequest<Map<String, dynamic>>(
        '/rest/V1/customers',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Customer.fromJson(response.data!);
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          final message = errorData['message'] ?? 'Registration failed';
          throw Exception(message);
        }
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Get current customer information
  Future<Customer> getCurrentCustomer() async {
    try {
      final response = await _client.authenticatedRequest<Map<String, dynamic>>(
        '/rest/V1/customers/me',
      );

      if (response.statusCode == 200) {
        return Customer.fromJson(response.data!);
      } else {
        throw Exception(
          'Failed to get customer info: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('User not authenticated');
      }
      throw Exception('Failed to get customer info: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get customer info: $e');
    }
  }

  /// Update customer information
  Future<Customer> updateCustomer({
    required CustomerUpdateRequest request,
  }) async {
    try {
      final response = await _client.authenticatedRequest<Map<String, dynamic>>(
        '/rest/V1/customers/me',
        options: Options(method: 'PUT'),
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Customer.fromJson(response.data!);
      } else {
        throw Exception('Failed to update customer: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('User not authenticated');
      }
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          final message = errorData['message'] ?? 'Update failed';
          throw Exception(message);
        }
      }
      throw Exception('Failed to update customer: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  /// Change customer password
  Future<bool> changePassword({required PasswordChangeRequest request}) async {
    try {
      final response = await _client.authenticatedRequest(
        '/rest/V1/customers/me/password',
        data: request.toJson(),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('User not authenticated');
      }
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          final message = errorData['message'] ?? 'Password change failed';
          throw Exception(message);
        }
      }
      throw Exception('Password change failed: ${e.message}');
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  /// Reset customer password
  Future<bool> resetPassword({required String email}) async {
    try {
      final response = await _client.guestRequest(
        '/rest/V1/customers/password',
        data: {'email': email, 'template': 'email_reset', 'websiteId': 1},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          final message = errorData['message'] ?? 'Password reset failed';
          throw Exception(message);
        }
      }
      throw Exception('Password reset failed: ${e.message}');
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Social login
  Future<AuthResponse> socialLogin({
    required String provider,
    required String token,
    String? email,
    String? firstname,
    String? lastname,
  }) async {
    try {
      // This endpoint might need to be customized based on Magento setup
      final response = await _client.guestRequest<Map<String, dynamic>>(
        '/rest/V1/integration/social/login',
        data: {
          'provider': provider,
          'token': token,
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
        },
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // Store tokens
        await _client.storeTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          customerId: authResponse.customer.id,
        );

        return authResponse;
      } else {
        throw Exception('Social login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Social login failed: ${e.message}');
    } catch (e) {
      throw Exception('Social login failed: $e');
    }
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken({required String refreshToken}) async {
    try {
      final response = await _client.guestRequest<Map<String, dynamic>>(
        '/rest/V1/integration/customer/token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // Store new tokens
        await _client.storeTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          customerId: authResponse.customer.id,
        );

        return authResponse;
      } else {
        throw Exception('Token refresh failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Token refresh failed: ${e.message}');
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  /// Logout customer
  Future<void> logout() async {
    try {
      await _client.logout();
    } catch (e) {
      // Even if logout API call fails, clear local tokens
      print('Logout failed: $e');
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _client.isAuthenticated;

  /// Get current customer ID
  int? get currentCustomerId => _client.currentCustomerId;
}
