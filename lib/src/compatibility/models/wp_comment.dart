/// WordPress Comment Compatibility Model

import '../wp_constants.dart';
import 'wp_user.dart';

class Comment {
  int? id;
  int? post;
  int? parent;
  int? author;
  String? authorName;
  String? authorEmail;
  String? authorUrl;
  String? authorIp;
  String? authorUserAgent;
  String? date;
  String? dateGmt;
  Content? content;
  String? link;
  CommentStatus? status;
  CommentType? type;
  Map<String, dynamic>? authorAvatarUrls;
  Map<String, dynamic>? meta;
  Links? lLinks;

  Comment({
    this.id,
    this.post,
    this.parent,
    this.author,
    this.authorName,
    this.authorEmail,
    this.authorUrl,
    this.authorIp,
    this.authorUserAgent,
    this.date,
    this.dateGmt,
    this.content,
    this.link,
    this.status,
    this.type,
    this.authorAvatarUrls,
    this.meta,
    this.lLinks,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = json['post'];
    parent = json['parent'];
    author = json['author'];
    authorName = json['author_name'];
    authorEmail = json['author_email'];
    authorUrl = json['author_url'];
    authorIp = json['author_ip'];
    authorUserAgent = json['author_user_agent'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    content = json['content'] != null
        ? Content.fromJson(json['content'])
        : null;
    link = json['link'];
    status = _parseCommentStatus(json['status']);
    type = _parseCommentType(json['type']);
    authorAvatarUrls = json['author_avatar_urls'];
    meta = json['meta'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (post != null) data['post'] = post;
    if (parent != null) data['parent'] = parent;
    if (author != null) data['author'] = author;
    if (authorName != null) data['author_name'] = authorName;
    if (authorEmail != null) data['author_email'] = authorEmail;
    if (authorUrl != null) data['author_url'] = authorUrl;
    if (authorIp != null) data['author_ip'] = authorIp;
    if (authorUserAgent != null) data['author_user_agent'] = authorUserAgent;
    if (date != null) data['date'] = date;
    if (dateGmt != null) data['date_gmt'] = dateGmt;
    if (content != null) data['content'] = content!.toJson();
    if (link != null) data['link'] = link;
    if (status != null) data['status'] = enumStringToName(status.toString());
    if (type != null) data['type'] = enumStringToName(type.toString());
    if (authorAvatarUrls != null) data['author_avatar_urls'] = authorAvatarUrls;
    if (meta != null) data['meta'] = meta;
    if (lLinks != null) data['_links'] = lLinks!.toJson();
    return data;
  }

  CommentStatus? _parseCommentStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'approved':
        return CommentStatus.approve;
      case 'hold':
        return CommentStatus.hold;
      case 'spam':
        return CommentStatus.spam;
      case 'trash':
        return CommentStatus.trash;
      default:
        return CommentStatus.approve;
    }
  }

  CommentType? _parseCommentType(String? type) {
    if (type == null) return null;
    switch (type) {
      case 'comment':
        return CommentType.comment;
      default:
        return CommentType.comment;
    }
  }
}

class Content {
  String? rendered;
  String? raw;

  Content({this.rendered, this.raw});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw};
  }
}

class CommentHierarchy {
  Comment? comment;
  List<CommentHierarchy>? children;

  CommentHierarchy({this.comment, this.children});
}
