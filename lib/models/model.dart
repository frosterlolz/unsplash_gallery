class PhotoList {
  List<Photo>? photos;

  PhotoList({this.photos});

  PhotoList.fromJson(List<dynamic> json) {
    photos = <Photo>[];
    for (var value in json) {
      photos!.add(Photo.fromJson(value as Map<String, dynamic>));
    }
  }

  List<dynamic> toJson() {
    List<dynamic> result = <dynamic>[];

    for (var element in photos!) {
      result.add(element.toJson());
    }

    return result;
  }
}

class Photo {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? promotedAt;
  int? width;
  int? height;
  String? color;
  String? description;
  String? altDescription;
  Urls? urls;
  Links? links;
  //List<Null> categories;
  int? likes;
  bool? likedByUser;
  //List<Null> currentUserCollections;
  Sponsorship? sponsorship;
  Sponsor? user;

  Photo(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.promotedAt,
        this.width,
        this.height,
        this.color,
        this.description,
        this.altDescription,
        this.urls,
        this.links,
        //this.categories,
        this.likes,
        this.likedByUser,
        //this.currentUserCollections,
        this.sponsorship,
        this.user});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    promotedAt = json['promoted_at'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    description = json['description'];
    altDescription = json['alt_description'];
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    //был пустой объект, его генератор не смог обработать
    //в этом примере он на мне нужен
    //комментируем
    // if (json['categories'] != null) {
    //   categories = new List<Null>();
    //   json['categories'].forEach((v) {
    //     categories.add(new Null.fromJson(v));
    //   });
    // }
    likes = json['likes'];
    likedByUser = json['liked_by_user'] ?? false;
    //был пустой объект, его генератор не смог обработать
    //в этом примере он на мне нужен
    //комментируем
    // if (json['current_user_collections'] != null) {
    //   currentUserCollections = new List<Null>();
    //   json['current_user_collections'].forEach((v) {
    //     currentUserCollections.add(new Null.fromJson(v));
    //   });
    // }
    sponsorship = json['sponsorship'] != null
        ? Sponsorship.fromJson(json['sponsorship'])
        : null;
    user = json['user'] != null ? Sponsor.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['promoted_at'] = promotedAt;
    data['width'] = width;
    data['height'] = height;
    data['color'] = color;
    data['description'] = description;
    data['alt_description'] = altDescription;
    if (urls != null) {
      data['urls'] = urls!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    //был пустой объект, его генератор не смог обработать
    //в этом примере он на мне нужен
    //комментируем
    // if (this.categories != null) {
    //   data['categories'] = this.categories.map((v) => v.toJson()).toList();
    // }
    data['likes'] = likes;
    data['liked_by_user'] = likedByUser;
    //был пустой объект, его генератор не смог обработать
    //в этом примере он на мне нужен
    //комментируем
    // if (this.currentUserCollections != null) {
    //   data['current_user_collections'] =
    //       this.currentUserCollections.map((v) => v.toJson()).toList();
    // }
    if (sponsorship != null) {
      data['sponsorship'] = sponsorship!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Urls {
  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;

  Urls({this.raw, this.full, this.regular, this.small, this.thumb});

  Urls.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    full = json['full'];
    regular = json['regular'];
    small = json['small'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['full'] = full;
    data['regular'] = regular;
    data['small'] = small;
    data['thumb'] = thumb;
    return data;
  }
}

class Links {
  String? self;
  String? html;
  String? download;
  String? downloadLocation;

  Links({this.self, this.html, this.download, this.downloadLocation});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    download = json['download'];
    downloadLocation = json['download_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['download'] = download;
    data['download_location'] = downloadLocation;
    return data;
  }
}

class Sponsorship {
  List<String>? impressionUrls;
  String? tagline;
  String? taglineUrl;
  Sponsor? sponsor;

  Sponsorship(
      {this.impressionUrls, this.tagline, this.taglineUrl, this.sponsor});

  Sponsorship.fromJson(Map<String, dynamic> json) {
    impressionUrls = json['impression_urls'].cast<String>();
    tagline = json['tagline'];
    taglineUrl = json['tagline_url'];
    sponsor =
    json['sponsor'] != null ? Sponsor.fromJson(json['sponsor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['impression_urls'] = impressionUrls;
    data['tagline'] = tagline;
    data['tagline_url'] = taglineUrl;
    if (sponsor != null) {
      data['sponsor'] = sponsor!.toJson();
    }
    return data;
  }
}

class Sponsor {
  String? id;
  String? updatedAt;
  String? username;
  String? name;
  String? firstName;
  String? lastName;
  String? twitterUsername;
  String? portfolioUrl;
  String? bio;
  String? location;
  Links? links;
  ProfileImage? profileImage;
  String? instagramUsername;
  int? totalCollections;
  int? totalLikes;
  int? totalPhotos;
  bool? acceptedTos;

  Sponsor(
      {this.id,
        this.updatedAt,
        this.username,
        this.name,
        this.firstName,
        this.lastName,
        this.twitterUsername,
        this.portfolioUrl,
        this.bio,
        this.location,
        this.links,
        this.profileImage,
        this.instagramUsername,
        this.totalCollections,
        this.totalLikes,
        this.totalPhotos,
        this.acceptedTos});

  Sponsor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedAt = json['updated_at'];
    username = json['username'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    twitterUsername = json['twitter_username'];
    portfolioUrl = json['portfolio_url'];
    bio = json['bio'];
    location = json['location'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    profileImage = json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'])
        : null;
    instagramUsername = json['instagram_username'];
    totalCollections = json['total_collections'];
    totalLikes = json['total_likes'];
    totalPhotos = json['total_photos'];
    acceptedTos = json['accepted_tos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['twitter_username'] = twitterUsername;
    data['portfolio_url'] = portfolioUrl;
    data['bio'] = bio;
    data['location'] = location;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (profileImage != null) {
      data['profile_image'] = profileImage!.toJson();
    }
    data['instagram_username'] = instagramUsername;
    data['total_collections'] = totalCollections;
    data['total_likes'] = totalLikes;
    data['total_photos'] = totalPhotos;
    data['accepted_tos'] = acceptedTos;
    return data;
  }
}

class SponsorLinks {
  //changed the name
  String? self;
  String? html;
  String? photos;
  String? likes;
  String? portfolio;
  String? following;
  String? followers;

  SponsorLinks(
      {this.self,
        this.html,
        this.photos,
        this.likes,
        this.portfolio,
        this.following,
        this.followers});

  SponsorLinks.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    photos = json['photos'];
    likes = json['likes'];
    portfolio = json['portfolio'];
    following = json['following'];
    followers = json['followers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['photos'] = photos;
    data['likes'] = likes;
    data['portfolio'] = portfolio;
    data['following'] = following;
    data['followers'] = followers;
    return data;
  }
}

class ProfileImage {
  String? small;
  String? medium;
  String? large;

  ProfileImage({this.small, this.medium, this.large});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

class CollectionList {
  List<Collection>? collections;

  CollectionList({this.collections});

  CollectionList.fromJson(List<dynamic> json) {
    collections = <Collection>[];
    for (var value in json) {
      collections!.add(Collection.fromJson(value as Map<String, dynamic>));
    }
  }
  List<dynamic> toJson() {
    List<dynamic> result = <dynamic>[];

    for (var element in collections!) {
      result.add(element.toJson());
    }

    return result;
  }
}

class Collection{
  String? id;
  String? title;
  String? description;
  DateTime? publishedAt;
  // DateTime? lastCollectedAt;
  DateTime? updatedAt;
  bool? curated;
  bool? featured;
  int? totalPhotos;
  bool? private;
  String? shareKey;
  // List<Tag>? tags;
  Links? links;
  Sponsor? user;
  Photo? coverPhoto;
  // List<PreviewPhoto>? previewPhotos;

  Collection({
    this.id,
    this.title,
    this.description,
    this.publishedAt,
    // this.lastCollectedAt,
    this.updatedAt,
    this.curated,
    this.featured,
    this.totalPhotos,
    this.private,
    this.shareKey,
    // this.tags,
    this.links,
    this.user,
    this.coverPhoto,
    // this.previewPhotos,
  });

  Collection.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    publishedAt = DateTime.parse(json["published_at"]);
    // lastCollectedAt = DateTime.parse(json["last_collected_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
    curated = json["curated"];
    featured = json["featured"];
    totalPhotos = json["total_photos"];
    private = json["private"];
    shareKey = json["share_key"];
    // tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x)));
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    // links = Links.fromJson(json["links"]);
    user = json['user'] != null ? Sponsor.fromJson(json['user']) : null;
    // user = Sponsor.fromJson(json["user"]);
    coverPhoto = Photo.fromJson(json["cover_photo"]);
    // previewPhotos: List<PreviewPhoto>.from(json["preview_photos"].map((x) => PreviewPhoto.fromJson(x))),
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["title"] = title;
    data['description'] = description;
    data["published_at"] = publishedAt;
    // data["last_collected_at"] = this.lastCollectedAt;
    data["updated_at"] = updatedAt;
    data["curated"] = curated;
    data["featured"] = featured;
    data["total_photos"] = totalPhotos;
    data["private"] = private;
    data["share_key"] = shareKey;
    // "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    data['links'] = links!.toJson();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data["cover_photo"] = coverPhoto!.toJson();
    // "preview_photos": List<dynamic>.from(previewPhotos.map((x) => x.toJson())),
    return data;
  }
}
