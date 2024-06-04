import 'dart:convert';

Album albumFromJson(String str) => Album.fromJson(json.decode(str));

String albumToJson(Album data) => json.encode(data.toJson());

class Album {
  Albums albums;

  Album({
    required this.albums,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        albums: Albums.fromJson(json['albums']),
      );

  Map<String, dynamic> toJson() => {
        'albums': albums.toJson(),
      };

  @override
  String toString() {
    return 'Album(albums: $albums)';
  }
}

class Albums {
  List<Item> items;

  Albums({
    required this.items,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Albums(items: $items)';
  }
}

class Item {
  String name;
  List<Artist> artists;
  List<Image> images;

  Item({
    required this.name,
    required this.artists,
    required this.images,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json['name'],
        artists:
            List<Artist>.from(json['artists'].map((x) => Artist.fromJson(x))),
        images: List<Image>.from(json['images'].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'artists': List<dynamic>.from(artists.map((x) => x.toJson())),
        'images': List<dynamic>.from(images.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Item(name: $name, artists: $artists, images: $images)';
  }
}

class Artist {
  String name;

  Artist({
    required this.name,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  String toString() {
    return 'Artist(name: $name)';
  }
}

class Image {
  String url;

  Image({
    required this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
      };

  @override
  String toString() => 'Image(url: $url)';
}
