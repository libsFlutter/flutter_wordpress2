/// Flutter WordPress Compatibility Layer
///
/// This library provides backward compatibility with the standard flutter_wordpress
/// library while offering enhanced functionality through the advanced architecture.
///
/// This allows seamless migration from flutter_wordpress to flutter_wordpress2
/// without breaking existing applications.

// Export standard WordPress classes for backward compatibility
export 'src/compatibility/wordpress_compatibility.dart';
export 'src/compatibility/models/wp_post.dart';
export 'src/compatibility/models/wp_user.dart';
export 'src/compatibility/models/wp_comment.dart' hide Content, Guid, CommentHierarchy;
export 'src/compatibility/models/wp_category.dart';
export 'src/compatibility/models/wp_tag.dart';
export 'src/compatibility/models/wp_media.dart' hide Guid;
export 'src/compatibility/models/wp_page.dart';
export 'src/compatibility/params/wp_params_post_list.dart';
export 'src/compatibility/params/wp_params_comment_list.dart';
export 'src/compatibility/params/wp_params_user_list.dart';
export 'src/compatibility/params/wp_params_category_list.dart';
export 'src/compatibility/params/wp_params_tag_list.dart';
export 'src/compatibility/params/wp_params_media_list.dart';
export 'src/compatibility/params/wp_params_page_list.dart';
export 'src/compatibility/wp_constants.dart';
export 'src/compatibility/wp_error.dart';

// Re-export enhanced functionality for advanced users
export 'flutter_magento.dart'
    hide
        // Hide Magento-specific exports to avoid confusion
        MagentoApiClient,
        AuthApi,
        ProductApi,
        CartApi,
        OrderApi;
