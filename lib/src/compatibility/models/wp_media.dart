/// WordPress Media Compatibility Model

import '../wp_constants.dart';
import 'wp_user.dart';

class Media {
  int? id;
  String? date;
  String? dateGmt;
  Guid? guid;
  String? modified;
  String? modifiedGmt;
  String? slug;
  MediaStatus? status;
  String? type;
  String? link;
  Title? title;
  int? author;
  CommentStatus? commentStatus;
  PingStatus? pingStatus;
  String? template;
  Map<String, dynamic>? meta;
  Description? description;
  Caption? caption;
  String? altText;
  String? mediaType;
  String? mimeType;
  MediaDetails? mediaDetails;
  int? post;
  String? sourceUrl;
  Links? lLinks;

  Media({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.author,
    this.commentStatus,
    this.pingStatus,
    this.template,
    this.meta,
    this.description,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.post,
    this.sourceUrl,
    this.lLinks,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = _parseMediaStatus(json['status']);
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    author = json['author'];
    commentStatus = _parseCommentStatus(json['comment_status']);
    pingStatus = _parsePingStatus(json['ping_status']);
    template = json['template'];
    meta = json['meta'];
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    caption = json['caption'] != null
        ? Caption.fromJson(json['caption'])
        : null;
    altText = json['alt_text'];
    mediaType = json['media_type'];
    mimeType = json['mime_type'];
    mediaDetails = json['media_details'] != null
        ? MediaDetails.fromJson(json['media_details'])
        : null;
    post = json['post'];
    sourceUrl = json['source_url'];
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
    if (slug != null) data['slug'] = slug;
    if (status != null) data['status'] = enumStringToName(status.toString());
    if (type != null) data['type'] = type;
    if (link != null) data['link'] = link;
    if (title != null) data['title'] = title!.toJson();
    if (author != null) data['author'] = author;
    if (commentStatus != null)
      data['comment_status'] = enumStringToName(commentStatus.toString());
    if (pingStatus != null)
      data['ping_status'] = enumStringToName(pingStatus.toString());
    if (template != null) data['template'] = template;
    if (meta != null) data['meta'] = meta;
    if (description != null) data['description'] = description!.toJson();
    if (caption != null) data['caption'] = caption!.toJson();
    if (altText != null) data['alt_text'] = altText;
    if (mediaType != null) data['media_type'] = mediaType;
    if (mimeType != null) data['mime_type'] = mimeType;
    if (mediaDetails != null) data['media_details'] = mediaDetails!.toJson();
    if (post != null) data['post'] = post;
    if (sourceUrl != null) data['source_url'] = sourceUrl;
    if (lLinks != null) data['_links'] = lLinks!.toJson();
    return data;
  }

  MediaStatus? _parseMediaStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'inherit':
        return MediaStatus.inherit;
      case 'publish':
        return MediaStatus.publish;
      case 'future':
        return MediaStatus.future;
      case 'draft':
        return MediaStatus.draft;
      case 'pending':
        return MediaStatus.pending;
      case 'private':
        return MediaStatus.private;
      default:
        return MediaStatus.inherit;
    }
  }

  CommentStatus? _parseCommentStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'open':
        return CommentStatus.approve;
      case 'closed':
        return CommentStatus.hold;
      default:
        return CommentStatus.approve;
    }
  }

  PingStatus? _parsePingStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'open':
        return PingStatus.open;
      case 'closed':
        return PingStatus.closed;
      default:
        return PingStatus.closed;
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

class Description {
  String? rendered;
  String? raw;

  Description({this.rendered, this.raw});

  Description.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw};
  }
}

class Caption {
  String? rendered;
  String? raw;

  Caption({this.rendered, this.raw});

  Caption.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'raw': raw};
  }
}

class MediaDetails {
  int? width;
  int? height;
  String? file;
  Map<String, dynamic>? sizes;
  Map<String, dynamic>? imageMeta;

  MediaDetails({
    this.width,
    this.height,
    this.file,
    this.sizes,
    this.imageMeta,
  });

  MediaDetails.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    file = json['file'];
    sizes = json['sizes'];
    imageMeta = json['image_meta'];
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'file': file,
      'sizes': sizes,
      'image_meta': imageMeta,
    };
  }
}

enum PingStatus { open, closed }
