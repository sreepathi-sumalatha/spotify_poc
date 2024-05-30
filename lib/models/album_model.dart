// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // To parse this JSON data, do
// //
// //     final album = albumFromJson(jsonString);

// import 'dart:convert';

// Album albumFromJson(String str) => Album.fromJson(json.decode(str));

// // String albumToJson(Album data) => json.encode(data.toJson());

// class Album {
//   String albumType;
//   int totalTracks;
//   List<String> availableMarkets;

//   String href;
//   String id;
//   List<Image> images;
//   String name;
//   DateTime releaseDate;
//   String releaseDatePrecision;
//   String type;
//   String uri;
//   List<Artist> artists;

//   List<dynamic> genres;
//   String label;
//   int popularity;

//   Album({
//     required this.albumType,
//     required this.totalTracks,
//     required this.availableMarkets,
//     required this.href,
//     required this.id,
//     required this.images,
//     required this.name,
//     required this.releaseDate,
//     required this.releaseDatePrecision,
//     required this.type,
//     required this.uri,
//     required this.artists,
//     required this.genres,
//     required this.label,
//     required this.popularity,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) => Album(
//         albumType: json["album_type"],
//         totalTracks: json["total_tracks"],
//         availableMarkets:
//             List<String>.from(json["available_markets"].map((x) => x)),
//         href: json["href"],
//         id: json["id"],
//         images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
//         name: json["name"],
//         releaseDate: DateTime.parse(json["release_date"]),
//         releaseDatePrecision: json["release_date_precision"],
//         type: json["type"],
//         uri: json["uri"],
//         artists:
//             List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
//         genres: List<dynamic>.from(json["genres"].map((x) => x)),
//         label: json["label"],
//         popularity: json["popularity"],
//       );

//   @override
//   String toString() {
//     return 'Album(albumType: $albumType, totalTracks: $totalTracks, availableMarkets: $availableMarkets, href: $href, id: $id, images: $images, name: $name, releaseDate: $releaseDate, releaseDatePrecision: $releaseDatePrecision, type: $type, uri: $uri, artists: $artists, genres: $genres, label: $label, popularity: $popularity)';
//   }
// }

// class Artist {
//   String href;
//   String? id;
//   String? name;

//   String uri;

//   Artist({
//     required this.href,
//     required this.id,
//     this.name,
//     required this.uri,
//   });

//   factory Artist.fromJson(Map<String, dynamic> json) => Artist(
//         href: json["href"],
//         id: json["id"],
//         name: json["name"],
//         uri: json["uri"],
//       );

//   @override
//   String toString() {
//     return 'Artist(href: $href, id: $id, name: $name, uri: $uri)';
//   }
// }

// class Image {
//   String url;
//   int height;
//   int width;

//   Image({
//     required this.url,
//     required this.height,
//     required this.width,
//   });

//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         url: json["url"],
//         height: json["height"],
//         width: json["width"],
//       );

//   @override
//   String toString() => 'Image(url: $url, height: $height, width: $width)';
// }

// To parse this JSON data, do
//
//     final album = albumFromJson(jsonString);

import 'dart:convert';

Album albumFromJson(String str) => Album.fromJson(json.decode(str));

String albumToJson(Album data) => json.encode(data.toJson());

class Album {
  Albums albums;

  Album({
    required this.albums,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        albums: Albums.fromJson(json["albums"]),
      );

  Map<String, dynamic> toJson() => {
        "albums": albums.toJson(),
      };
  @override
  String toString() {
    return 'Album(albums: $albums)';
  }
}

class Albums {
  String href;
  List<Item> items;
  int limit;
  String next;
  int offset;
  String previous;
  int total;

  Albums({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        href: json["href"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        limit: json["limit"],
        next: json["next"],
        offset: json["offset"],
        previous: json["previous"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "limit": limit,
        "next": next,
        "offset": offset,
        "previous": previous,
        "total": total,
      };

  @override
  String toString() {
    return 'Albums(href: $href, items: $items, limit: $limit, next: $next, offset: $offset, previous: $previous, total: $total)';
  }
}

class Item {
  AlbumType? albumType;
  List<Artist> artists;
  List<String> availableMarkets;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<Image> images;
  String name;
  DateTime releaseDate;
  ReleaseDatePrecision? releaseDatePrecision;
  int totalTracks;
  ItemType? type;
  String uri;

  Item({
    this.albumType,
    required this.artists,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    this.type,
    required this.uri,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        albumType: albumTypeValues.map[json["album_type"]],
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        availableMarkets:
            List<String>.from(json["available_markets"].map((x) => x)),
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        releaseDate: DateTime.parse(json["release_date"]),
        releaseDatePrecision:
            releaseDatePrecisionValues.map[json["release_date_precision"]]!,
        totalTracks: json["total_tracks"],
        type: itemTypeValues.map[json["type"]],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "album_type": albumTypeValues.reverse[albumType],
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "available_markets": List<dynamic>.from(availableMarkets.map((x) => x)),
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "release_date_precision":
            releaseDatePrecisionValues.reverse[releaseDatePrecision],
        "total_tracks": totalTracks,
        "type": itemTypeValues.reverse[type],
        "uri": uri,
      };

  @override
  String toString() {
    return 'Item(albumType: $albumType, artists: $artists, availableMarkets: $availableMarkets, externalUrls: $externalUrls, href: $href, id: $id, images: $images, name: $name, releaseDate: $releaseDate, releaseDatePrecision: $releaseDatePrecision, totalTracks: $totalTracks, uri: $uri)';
  }
}

enum AlbumType { SINGLE }

final albumTypeValues = EnumValues({"single": AlbumType.SINGLE});

class Artist {
  ExternalUrls externalUrls;
  String href;
  String id;
  String name;
  ArtistType? type;
  String uri;

  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        name: json["name"],
        type: artistTypeValues.map[json["type"]],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "name": name,
        "type": artistTypeValues.reverse[type],
        "uri": uri,
      };

  @override
  String toString() {
    return 'Artist(externalUrls: $externalUrls, href: $href, id: $id, name: $name, uri: $uri)';
  }
}

class ExternalUrls {
  String spotify;

  ExternalUrls({
    required this.spotify,
  });

  factory ExternalUrls.fromJson(Map<String, dynamic> json) => ExternalUrls(
        spotify: json["spotify"],
      );

  Map<String, dynamic> toJson() => {
        "spotify": spotify,
      };
}

enum ArtistType { ARTIST }

final artistTypeValues = EnumValues({"artist": ArtistType.ARTIST});

class Image {
  int height;
  String url;
  int width;

  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        height: json["height"],
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "url": url,
        "width": width,
      };
}

enum ReleaseDatePrecision { DAY }

final releaseDatePrecisionValues =
    EnumValues({"day": ReleaseDatePrecision.DAY});

enum ItemType { ALBUM }

final itemTypeValues = EnumValues({"album": ItemType.ALBUM});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
