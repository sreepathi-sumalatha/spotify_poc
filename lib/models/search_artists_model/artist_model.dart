import 'dart:convert';

class ArtistModel {
  final String name;
  final int popularity;
  final String image;

  ArtistModel({
    required this.name,
    required this.popularity,
    required this.image,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      name: json['name'],
      popularity: json['popularity'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'popularity': popularity,
      'image': image,
    };
  }

  static List<ArtistModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ArtistModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ArtistModel> artists) {
    return artists.map((artist) => artist.toJson()).toList();
  }

  @override
  String toString() {
    return 'ArtistModel(name: $name, popularity: $popularity, image: $image)';
  }
}

List<ArtistModel> artistModelFromJson(String str) {
  final jsonData = json.decode(str);
  return ArtistModel.fromJsonList(jsonData);
}

String artistModelToJson(List<ArtistModel> data) {
  final jsonData = ArtistModel.toJsonList(data);
  return json.encode(jsonData);
}
