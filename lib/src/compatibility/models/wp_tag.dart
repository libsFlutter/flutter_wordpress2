/// WordPress Tag Compatibility Model

import 'wp_user.dart';

class Tag {
  int? id;
  int? count;
  String? description;
  String? link;
  String? name;
  String? slug;
  String? taxonomy;
  Map<String, dynamic>? meta;
  Links? lLinks;

  Tag({
    this.id,
    this.count,
    this.description,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.meta,
    this.lLinks,
  });

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    description = json['description'];
    link = json['link'];
    name = json['name'];
    slug = json['slug'];
    taxonomy = json['taxonomy'];
    meta = json['meta'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (count != null) data['count'] = count;
    if (description != null) data['description'] = description;
    if (link != null) data['link'] = link;
    if (name != null) data['name'] = name;
    if (slug != null) data['slug'] = slug;
    if (taxonomy != null) data['taxonomy'] = taxonomy;
    if (meta != null) data['meta'] = meta;
    if (lLinks != null) data['_links'] = lLinks!.toJson();
    return data;
  }
}
