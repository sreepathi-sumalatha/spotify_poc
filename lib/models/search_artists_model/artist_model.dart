// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // here need to add serilization and deserilization
// class ArtistModel {
//   final String name;
//   final int popularity;
//   final String image;
//   ArtistModel({
//     required this.name,
//     required this.popularity,
//     required this.image,
//   });
// }
// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  // Factory constructor to create an ArtistModel from JSON
  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      name: json['name'],
      popularity: json['popularity'],
      image: json['image'],
    );
  }

  // Method to convert an ArtistModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'popularity': popularity,
      'image': image,
    };
  }

  // Static method to create a list of ArtistModel from JSON
  static List<ArtistModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ArtistModel.fromJson(json)).toList();
  }

  // Static method to convert a list of ArtistModel instances to JSON
  static List<Map<String, dynamic>> toJsonList(List<ArtistModel> artists) {
    return artists.map((artist) => artist.toJson()).toList();
  }

  @override
  String toString() {
    return 'ArtistModel(name: $name, popularity: $popularity, image: $image)';
  }
}

// Utility function to convert JSON string to a list of ArtistModel
List<ArtistModel> artistModelFromJson(String str) {
  final jsonData = json.decode(str);
  return ArtistModel.fromJsonList(jsonData);
}

// Utility function to convert a list of ArtistModel to JSON string
String artistModelToJson(List<ArtistModel> data) {
  final jsonData = ArtistModel.toJsonList(data);
  return json.encode(jsonData);
}
