import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_wordpress2/flutter_wordpress2.dart' as wp;

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  List<wp.Media> _mediaList = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final wordpressProvider = Provider.of<wp.WordPressProvider>(
        context,
        listen: false,
      );

      if (!wordpressProvider.isInitialized) {
        await _initializeWordPress();
      }

      final mediaList = await wordpressProvider.wordpress.fetchMediaList(
        params: wp.ParamsMediaList(
          context: wp.WordPressContext.view,
          pageNum: 1,
          perPage: 20,
          orderBy: wp.MediaOrderBy.date,
          order: wp.Order.desc,
        ),
      );

      setState(() {
        _mediaList = mediaList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
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
      enableImageCaching: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPress Media'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMedia),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading media',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchMedia, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_mediaList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No media found'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchMedia,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: _mediaList.length,
        itemBuilder: (context, index) {
          final media = _mediaList[index];
          return MediaCard(media: media);
        },
      ),
    );
  }
}

class MediaCard extends StatelessWidget {
  final wp.Media media;

  const MediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediaDetailScreen(media: media),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                child: _buildMediaPreview(),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title?.rendered ?? 'Untitled',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    media.mediaType ?? 'Unknown type',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (media.mediaType == 'image' && media.sourceUrl != null) {
      return CachedNetworkImage(
        imageUrl: media.sourceUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: Icon(
            Icons.broken_image,
            color: Colors.grey.shade400,
            size: 48,
          ),
        ),
      );
    }

    // Non-image media types
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          _getMediaIcon(media.mediaType),
          color: Colors.grey.shade400,
          size: 48,
        ),
      ),
    );
  }

  IconData _getMediaIcon(String? mediaType) {
    switch (mediaType?.toLowerCase()) {
      case 'video':
        return Icons.video_file;
      case 'audio':
        return Icons.audio_file;
      case 'application':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class MediaDetailScreen extends StatelessWidget {
  final wp.Media media;

  const MediaDetailScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(media.title?.rendered ?? 'Media Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media preview
            if (media.mediaType == 'image' && media.sourceUrl != null)
              Container(
                width: double.infinity,
                height: 300,
                child: CachedNetworkImage(
                  imageUrl: media.sourceUrl!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey.shade400,
                      size: 64,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Title
            Text(
              media.title?.rendered ?? 'Untitled',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Meta information
            _buildInfoRow('Type', media.mediaType ?? 'Unknown'),
            _buildInfoRow(
              'Date',
              media.date?.toString().split(' ')[0] ?? 'Unknown',
            ),
            if (media.mediaDetails?.width != null &&
                media.mediaDetails?.height != null)
              _buildInfoRow(
                'Dimensions',
                '${media.mediaDetails!.width} × ${media.mediaDetails!.height}',
              ),
            if (media.mediaDetails?.filesize != null)
              _buildInfoRow(
                'Size',
                _formatFileSize(media.mediaDetails!.filesize!),
              ),

            const SizedBox(height: 16),

            // Description
            if (media.description?.rendered != null &&
                media.description!.rendered!.isNotEmpty) ...[
              Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _stripHtml(media.description!.rendered!),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  String _stripHtml(String html) {
    final RegExp htmlTags = RegExp(r'<[^>]*>');
    return html.replaceAll(htmlTags, '').trim();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
