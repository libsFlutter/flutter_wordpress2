/// WordPress User Compatibility Model
///
/// This class maintains backward compatibility with the original flutter_wordpress
/// User model while leveraging the enhanced architecture underneath.

class User {
  int? id;
  String? username;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? url;
  String? description;
  String? link;
  String? locale;
  String? nickname;
  String? slug;
  List<String>? roles;
  String? registeredDate;
  UserCapabilities? capabilities;
  UserExtraCapabilities? extraCapabilities;
  AvatarUrls? avatarUrls;
  Map<String, dynamic>? meta;
  Links? lLinks;
  String? password;

  User({
    this.id,
    this.username,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.url,
    this.description,
    this.link,
    this.locale,
    this.nickname,
    this.slug,
    this.roles,
    this.registeredDate,
    this.capabilities,
    this.extraCapabilities,
    this.avatarUrls,
    this.meta,
    this.lLinks,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    url = json['url'];
    description = json['description'];
    link = json['link'];
    locale = json['locale'];
    nickname = json['nickname'];
    slug = json['slug'];
    roles = json['roles']?.cast<String>();
    registeredDate = json['registered_date'];
    capabilities = json['capabilities'] != null
        ? UserCapabilities.fromJson(json['capabilities'])
        : null;
    extraCapabilities = json['extra_capabilities'] != null
        ? UserExtraCapabilities.fromJson(json['extra_capabilities'])
        : null;
    avatarUrls = json['avatar_urls'] != null
        ? AvatarUrls.fromJson(json['avatar_urls'])
        : null;
    meta = json['meta'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (username != null) data['username'] = username;
    if (name != null) data['name'] = name;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;
    if (url != null) data['url'] = url;
    if (description != null) data['description'] = description;
    if (link != null) data['link'] = link;
    if (locale != null) data['locale'] = locale;
    if (nickname != null) data['nickname'] = nickname;
    if (slug != null) data['slug'] = slug;
    if (roles != null) data['roles'] = roles;
    if (registeredDate != null) data['registered_date'] = registeredDate;
    if (capabilities != null) data['capabilities'] = capabilities!.toJson();
    if (extraCapabilities != null)
      data['extra_capabilities'] = extraCapabilities!.toJson();
    if (avatarUrls != null) data['avatar_urls'] = avatarUrls!.toJson();
    if (meta != null) data['meta'] = meta;
    if (lLinks != null) data['_links'] = lLinks!.toJson();
    if (password != null) data['password'] = password;
    return data;
  }
}

class UserCapabilities {
  bool? read;
  bool? level0;
  bool? subscriber;

  UserCapabilities({this.read, this.level0, this.subscriber});

  UserCapabilities.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    level0 = json['level_0'];
    subscriber = json['subscriber'];
  }

  Map<String, dynamic> toJson() {
    return {'read': read, 'level_0': level0, 'subscriber': subscriber};
  }
}

class UserExtraCapabilities {
  bool? subscriber;

  UserExtraCapabilities({this.subscriber});

  UserExtraCapabilities.fromJson(Map<String, dynamic> json) {
    subscriber = json['subscriber'];
  }

  Map<String, dynamic> toJson() {
    return {'subscriber': subscriber};
  }
}

class AvatarUrls {
  String? s24;
  String? s48;
  String? s96;

  AvatarUrls({this.s24, this.s48, this.s96});

  AvatarUrls.fromJson(Map<String, dynamic> json) {
    s24 = json['24'];
    s48 = json['48'];
    s96 = json['96'];
  }

  Map<String, dynamic> toJson() {
    return {'24': s24, '48': s48, '96': s96};
  }
}

class Links {
  List<Self>? self;
  List<Collection>? collection;

  Links({this.self, this.collection});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <Collection>[];
      json['collection'].forEach((v) {
        collection!.add(Collection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (self != null) {
      data['self'] = self!.map((v) => v.toJson()).toList();
    }
    if (collection != null) {
      data['collection'] = collection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class Collection {
  String? href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class FetchUsersResult {
  List<User> users;
  int totalUsers;

  FetchUsersResult(this.users, this.totalUsers);
}
