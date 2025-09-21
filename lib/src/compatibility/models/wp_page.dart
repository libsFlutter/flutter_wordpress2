/// WordPress Page Compatibility Model

import '../wp_constants.dart';
import 'wp_user.dart';

class Page {
  int? id;
  String? date;
  String? dateGmt;
  Guid? guid;
  String? modified;
  String? modifiedGmt;
  String? password;
  String? slug;
  PostPageStatus? status;
  String? type;
  String? link;
  Title? title;
  Content? content;
  Excerpt? excerpt;
  int? author;
  int? featuredMedia;
  int? parent;
  int? menuOrder;
  PostCommentStatus? commentStatus;
  PostPingStatus? pingStatus;
  String? template;
  Map<String, dynamic>? meta;
  Links? lLinks;

  Page({
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
    this.author,
    this.featuredMedia,
    this.parent,
    this.menuOrder,
    this.commentStatus,
    this.pingStatus,
    this.template,
    this.meta,
    this.lLinks,
  });

  Page.fromJson(Map<String, dynamic> json) {
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
    author = json['author'];
    featuredMedia = json['featured_media'];
    parent = json['parent'];
    menuOrder = json['menu_order'];
    commentStatus = _parseCommentStatus(json['comment_status']);
    pingStatus = _parsePingStatus(json['ping_status']);
    template = json['template'];
    meta = json['meta'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
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
    if (author != null) data['author'] = author;
    if (featuredMedia != null) data['featured_media'] = featuredMedia;
    if (parent != null) data['parent'] = parent;
    if (menuOrder != null) data['menu_order'] = menuOrder;
    if (commentStatus != null)
      data['comment_status'] = enumStringToName(commentStatus.toString());
    if (pingStatus != null)
      data['ping_status'] = enumStringToName(pingStatus.toString());
    if (template != null) data['template'] = template;
    if (meta != null) data['meta'] = meta;
    if (lLinks != null) data['_links'] = lLinks!.toJson();
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
