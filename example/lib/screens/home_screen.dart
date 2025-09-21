import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wordpress2/flutter_wordpress2.dart' as wp;
import '../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter WordPress 2.0 Example')),
      body: Consumer2<AppProvider, wp.WordPressProvider>(
        builder: (context, appProvider, wordpressProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Flutter WordPress 2.0!',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This example demonstrates the enhanced Flutter WordPress library with:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Content management system'),
                            Text('• Posts and pages'),
                            Text('• Media library'),
                            Text('• User management'),
                            Text('• Categories and tags'),
                            Text('• Offline support'),
                            Text('• Image caching'),
                            Text('• Real-time updates'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Connection Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WordPress Connection Status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              wordpressProvider.isInitialized
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: wordpressProvider.isInitialized
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              wordpressProvider.isInitialized
                                  ? 'Connected'
                                  : 'Not Connected',
                              style: TextStyle(
                                color: wordpressProvider.isInitialized
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (wordpressProvider.error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Error: ${wordpressProvider.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Features Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enhanced Features',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureRow(
                          'Offline Mode',
                          wordpressProvider.enableOfflineMode,
                          Icons.offline_bolt,
                        ),
                        _buildFeatureRow(
                          'Image Caching',
                          wordpressProvider.enableImageCaching,
                          Icons.image,
                        ),
                        _buildFeatureRow(
                          'Real-time Updates',
                          wordpressProvider.enableRealTime,
                          Icons.real_time_sync,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _QuickActionCard(
                        icon: Icons.settings,
                        title: 'Configure API',
                        subtitle: 'Set WordPress URL',
                        onTap: () => _navigateToTab(context, 6),
                      ),
                      _QuickActionCard(
                        icon: Icons.person,
                        title: 'Authentication',
                        subtitle: 'Login or Register',
                        onTap: () => _navigateToTab(context, 1),
                      ),
                      _QuickActionCard(
                        icon: Icons.article,
                        title: 'Browse Posts',
                        subtitle: 'View articles',
                        onTap: () => _navigateToTab(context, 2),
                      ),
                      _QuickActionCard(
                        icon: Icons.image,
                        title: 'Media Library',
                        subtitle: 'View images',
                        onTap: () => _navigateToTab(context, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureRow(String title, bool enabled, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: enabled ? Colors.green : Colors.grey),
          const SizedBox(width: 8),
          Text(title),
          const Spacer(),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: enabled ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    final mainScreenState = context
        .findAncestorStateOfType<State<StatefulWidget>>();
    if (mainScreenState != null && mainScreenState.mounted) {
      (mainScreenState as dynamic).setState(() {
        (mainScreenState as dynamic)._currentIndex = index;
      });
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
