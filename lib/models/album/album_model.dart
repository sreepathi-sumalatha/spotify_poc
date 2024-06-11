import 'dart:convert';

/// Convert a JSON string to a list of items
List<Item> itemsFromJson(String str) =>
    List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

/// Convert a list of items to a JSON string
String itemsToJson(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
