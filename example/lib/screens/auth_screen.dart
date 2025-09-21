import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wordpress2/flutter_wordpress2.dart' as wp;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  wp.User? _currentUser;
  String? _authToken;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final wordpressProvider = Provider.of<wp.WordPressProvider>(
        context,
        listen: false,
      );

      if (!wordpressProvider.isInitialized) {
        await _initializeWordPress();
      }

      if (_isLogin) {
        // Login
        final user = await wordpressProvider.wordpress.authenticateUser(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          _currentUser = user;
          _authToken = wordpressProvider.wordpress.getToken();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome, ${user.name}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Register (for demo purposes, we'll just show success)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! (Demo mode)'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeWordPress() async {
    final wordpressProvider = Provider.of<wp.WordPressProvider>(
      context,
      listen: false,
    );

    await wordpressProvider.initialize(
      baseUrl: 'https://demo.wp-api.org',
      authenticator: wp.WordPressAuthenticator.JWT,
    );
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _authToken = null;
      _usernameController.clear();
      _passwordController.clear();
      _emailController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WordPress Authentication')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _currentUser != null ? _buildUserProfile() : _buildAuthForm(),
      ),
    );
  }

  Widget _buildAuthForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode Toggle
          Center(
            child: ToggleButtons(
              isSelected: [_isLogin, !_isLogin],
              onPressed: (index) => _toggleMode(),
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Login'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Register'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Username/Email field
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: _isLogin ? 'Username or Email' : 'Username',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your ${_isLogin ? 'username or email' : 'username'}';
              }
              return null;
            },
            keyboardType: _isLogin
                ? TextInputType.emailAddress
                : TextInputType.text,
          ),

          const SizedBox(height: 16),

          // Email field (only for registration)
          if (!_isLogin) ...[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
          ],

          // Password field
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (!_isLogin && value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _authenticate,
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Processing...'),
                      ],
                    )
                  : Text(_isLogin ? 'Login' : 'Register'),
            ),
          ),

          const SizedBox(height: 16),

          // Info card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Demo Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This demo uses the WordPress.org test site. '
                    'You can try logging in with demo credentials or '
                    'test the registration flow (registration is simulated).',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: _currentUser!.avatarUrls?.s96 != null
                          ? NetworkImage(_currentUser!.avatarUrls!.s96!)
                          : null,
                      child: _currentUser!.avatarUrls?.s96 == null
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.blue.shade600,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentUser!.name ?? 'Unknown User',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (_currentUser!.slug != null)
                            Text(
                              '@${_currentUser!.slug}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // User details
                if (_currentUser!.description != null &&
                    _currentUser!.description!.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_currentUser!.description!),
                  const SizedBox(height: 16),
                ],

                // Additional info
                _buildInfoRow(
                  'User ID',
                  _currentUser!.id?.toString() ?? 'Unknown',
                ),
                if (_currentUser!.url != null)
                  _buildInfoRow('Website', _currentUser!.url!),
                if (_currentUser!.link != null)
                  _buildInfoRow('Profile Link', _currentUser!.link!),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Token info (for debugging)
        if (_authToken != null)
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Authentication Token',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Token: ${_authToken!.substring(0, 20)}...',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Authentication successful! You can now access protected endpoints.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Logout button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
