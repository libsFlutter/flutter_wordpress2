/// WordPress Post Compatibility Model
///
/// This class maintains backward compatibility with the original flutter_wordpress
/// Post model while leveraging the enhanced architecture underneath.

import '../wp_constants.dart';
import 'wp_user.dart';
import 'wp_comment.dart';
import 'wp_category.dart';
import 'wp_tag.dart';
import 'wp_media.dart';

class Post {
  /// ID of the post
  int? id;

  /// The date the post was published, in the site's Timezone.
  String? date;

  /// The date the post was published, in GMT.
  String? dateGmt;
  Guid? guid;
  String? modified;
  String? modifiedGmt;

  /// Password for the post in case it needs to be password protected.
  String? password;

  /// An alphanumeric identifier unique to each post.
  String? slug;

  /// The state in which the post should be created (draft, publish etc.)
  PostPageStatus? status;
  String? type;
  String? link;

  /// Post title
  Title? title;

  /// Post content
  Content? content;

  /// Post excerpt
  Excerpt? excerpt;

  /// Author ID of the post
  int? authorID;

  /// List of Category IDs
  List<int>? categoryIDs;

  /// List of Tag IDs
  List<int>? tagIDs;

  /// Featured media ID
  int? featuredMediaID;

  /// Whether the post should remain at the top of the list
  bool? sticky;

  /// Post format
  PostFormat? postFormat;

  /// Meta data
  Map<String, dynamic>? meta;

  /// Template used by the post
  String? template;

  /// Comment status
  PostCommentStatus? commentStatus;

  /// Ping status
  PostPingStatus? pingStatus;

  // Enhanced fields populated by fetchPosts
  User? author;
  List<Comment>? comments;
  List<CommentHierarchy>? commentsHierarchy;
  List<Category>? categories;
  List<Tag>? tags;
  Media? featuredMedia;
  List<Media>? attachments;

  Post({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.password,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.authorID,
    this.categoryIDs,
    this.tagIDs,
    this.featuredMediaID,
    this.sticky,
    this.postFormat,
    this.meta,
    this.template,
    this.commentStatus,
    this.pingStatus,
    this.author,
    this.comments,
    this.commentsHierarchy,
    this.categories,
    this.tags,
    this.featuredMedia,
    this.attachments,
  });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    password = json['password'];
    slug = json['slug'];
    status = _parsePostPageStatus(json['status']);
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    content = json['content'] != null
        ? Content.fromJson(json['content'])
        : null;
    excerpt = json['excerpt'] != null
        ? Excerpt.fromJson(json['excerpt'])
        : null;
    authorID = json['author'];
    categoryIDs = json['categories']?.cast<int>();
    tagIDs = json['tags']?.cast<int>();
    featuredMediaID = json['featured_media'];
    sticky = json['sticky'];
    postFormat = _parsePostFormat(json['format']);
    meta = json['meta'];
    template = json['template'];
    commentStatus = _parseCommentStatus(json['comment_status']);
    pingStatus = _parsePingStatus(json['ping_status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (date != null) data['date'] = date;
    if (dateGmt != null) data['date_gmt'] = dateGmt;
    if (guid != null) data['guid'] = guid!.toJson();
    if (modified != null) data['modified'] = modified;
    if (modifiedGmt != null) data['modified_gmt'] = modifiedGmt;
    if (password != null) data['password'] = password;
    if (slug != null) data['slug'] = slug;
    if (status != null) data['status'] = enumStringToName(status.toString());
    if (type != null) data['type'] = type;
    if (link != null) data['link'] = link;
    if (title != null) data['title'] = title!.toJson();
    if (content != null) data['content'] = content!.toJson();
    if (excerpt != null) data['excerpt'] = excerpt!.toJson();
    if (authorID != null) data['author'] = authorID;
    if (categoryIDs != null) data['categories'] = categoryIDs;
    if (tagIDs != null) data['tags'] = tagIDs;
    if (featuredMediaID != null) data['featured_media'] = featuredMediaID;
    if (sticky != null) data['sticky'] = sticky;
    if (postFormat != null)
      data['format'] = enumStringToName(postFormat.toString());
    if (meta != null) data['meta'] = meta;
    if (template != null) data['template'] = template;
    if (commentStatus != null)
      data['comment_status'] = enumStringToName(commentStatus.toString());
    if (pingStatus != null)
      data['ping_status'] = enumStringToName(pingStatus.toString());
    return data;
  }

  PostPageStatus? _parsePostPageStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'publish':
        return PostPageStatus.publish;
      case 'future':
        return PostPageStatus.future;
      case 'draft':
        return PostPageStatus.draft;
      case 'pending':
        return PostPageStatus.pending;
      case 'private':
        return PostPageStatus.private;
      default:
        return PostPageStatus.draft;
    }
  }

  PostFormat? _parsePostFormat(String? format) {
    if (format == null) return null;
    switch (format) {
      case 'standard':
        return PostFormat.standard;
      case 'aside':
        return PostFormat.aside;
      case 'chat':
        return PostFormat.chat;
      case 'gallery':
        return PostFormat.gallery;
      case 'link':
        return PostFormat.link;
      case 'image':
        return PostFormat.image;
      case 'quote':
        return PostFormat.quote;
      case 'status':
        return PostFormat.status;
      case 'video':
        return PostFormat.video;
      case 'audio':
        return PostFormat.audio;
      default:
        return PostFormat.standard;
    }
  }

  PostCommentStatus? _parseCommentStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'open':
        return PostCommentStatus.open;
      case 'closed':
        return PostCommentStatus.closed;
      default:
        return PostCommentStatus.open;
    }
  }

  PostPingStatus? _parsePingStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'open':
        return PostPingStatus.open;
      case 'closed':
        return PostPingStatus.closed;
      default:
        return PostPingStatus.closed;
    }
  }
}

class Guid {
  String? rendered;
  bool? raw;

  Guid({this.rendered, this.raw});

  Guid.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw};
  }
}

class Title {
  String? rendered;
  String? raw;

  Title({this.rendered, this.raw});

  Title.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw};
  }
}

class Content {
  String? rendered;
  String? raw;
  bool? protected;

  Content({this.rendered, this.raw, this.protected});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw, 'protected': protected};
  }
}

class Excerpt {
  String? rendered;
  String? raw;
  bool? protected;

  Excerpt({this.rendered, this.raw, this.protected});

  Excerpt.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw, 'protected': protected};
  }
}

// Import necessary models
class CommentHierarchy {
  Comment? comment;
  List<CommentHierarchy>? children;

  CommentHierarchy({this.comment, this.children});
}
