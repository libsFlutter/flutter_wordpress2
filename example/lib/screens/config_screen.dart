import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_wordpress2/flutter_wordpress2.dart' as wp;

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _connectionStatus;
  wp.WordPressAuthenticator _selectedAuth = wp.WordPressAuthenticator.JWT;
  bool _enableOfflineMode = true;
  bool _enableImageCaching = true;
  bool _enableRealTime = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _baseUrlController.text =
          prefs.getString('wp_base_url') ?? 'https://demo.wp-api.org';
      _usernameController.text = prefs.getString('wp_username') ?? '';
      _passwordController.text = prefs.getString('wp_password') ?? '';
      _enableOfflineMode = prefs.getBool('wp_offline_mode') ?? true;
      _enableImageCaching = prefs.getBool('wp_image_caching') ?? true;
      _enableRealTime = prefs.getBool('wp_real_time') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wp_base_url', _baseUrlController.text);
    await prefs.setString('wp_username', _usernameController.text);
    await prefs.setString('wp_password', _passwordController.text);
    await prefs.setBool('wp_offline_mode', _enableOfflineMode);
    await prefs.setBool('wp_image_caching', _enableImageCaching);
    await prefs.setBool('wp_real_time', _enableRealTime);
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _connectionStatus = null;
    });

    try {
      final wordpressProvider = Provider.of<wp.WordPressProvider>(
        context,
        listen: false,
      );

      await wordpressProvider.initialize(
        baseUrl: _baseUrlController.text.trim(),
        authenticator: _selectedAuth,
        adminName: _usernameController.text.trim().isNotEmpty
            ? _usernameController.text.trim()
            : null,
        adminKey: _passwordController.text.trim().isNotEmpty
            ? _passwordController.text.trim()
            : null,
        enableOfflineMode: _enableOfflineMode,
        enableImageCaching: _enableImageCaching,
        enableRealTime: _enableRealTime,
      );

      // Test by fetching a single post
      await wordpressProvider.wordpress.fetchPosts(
        postParams: wp.ParamsPostList(
          context: wp.WordPressContext.view,
          pageNum: 1,
          perPage: 1,
        ),
      );

      setState(() {
        _connectionStatus = 'Connection successful! ✅';
        _isLoading = false;
      });

      await _saveSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    try {
      final wordpressProvider = Provider.of<wp.WordPressProvider>(
        context,
        listen: false,
      );
      await wordpressProvider.clearCache();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing cache: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WordPress Configuration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connection Settings
              _buildSectionHeader('Connection Settings'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _baseUrlController,
                decoration: const InputDecoration(
                  labelText: 'WordPress Site URL',
                  hintText: 'https://your-site.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a WordPress site URL';
                  }
                  if (!Uri.tryParse(value)?.hasAbsolutePath ?? true) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 16),

              // Authentication Method
              Text(
                'Authentication Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<wp.WordPressAuthenticator>(
                value: _selectedAuth,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
                items: [
                  const DropdownMenuItem(
                    value: wp.WordPressAuthenticator.JWT,
                    child: Text('JWT (Recommended)'),
                  ),
                  const DropdownMenuItem(
                    value: wp.WordPressAuthenticator.ApplicationPasswords,
                    child: Text('Application Passwords'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedAuth = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              if (_selectedAuth == wp.WordPressAuthenticator.JWT) ...[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ],

              const SizedBox(height: 24),

              // Enhanced Features
              _buildSectionHeader('Enhanced Features'),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Offline Mode'),
                subtitle: const Text('Cache content for offline access'),
                value: _enableOfflineMode,
                onChanged: (value) {
                  setState(() {
                    _enableOfflineMode = value;
                  });
                },
              ),

              SwitchListTile(
                title: const Text('Image Caching'),
                subtitle: const Text('Cache images for faster loading'),
                value: _enableImageCaching,
                onChanged: (value) {
                  setState(() {
                    _enableImageCaching = value;
                  });
                },
              ),

              SwitchListTile(
                title: const Text('Real-time Updates'),
                subtitle: const Text('WebSocket support for live updates'),
                value: _enableRealTime,
                onChanged: (value) {
                  setState(() {
                    _enableRealTime = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Connection Test
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _testConnection,
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
                            Text('Testing Connection...'),
                          ],
                        )
                      : const Text('Test Connection & Save'),
                ),
              ),

              if (_connectionStatus != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _connectionStatus!.contains('successful')
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    border: Border.all(
                      color: _connectionStatus!.contains('successful')
                          ? Colors.green
                          : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _connectionStatus!,
                    style: TextStyle(
                      color: _connectionStatus!.contains('successful')
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Cache Management
              _buildSectionHeader('Cache Management'),
              const SizedBox(height: 16),

              Consumer<wp.WordPressProvider>(
                builder: (context, provider, child) {
                  final stats = provider.getCacheStats();
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cache Statistics',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ...stats.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                  ),
                                  Text(entry.value.toString()),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _clearCache,
                              child: const Text('Clear Cache'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
      ),
    );
  }
}
