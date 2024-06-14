import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';

void main() {
  group('ArtistModel', () {
    test('fromJson should return a valid ArtistModel object', () {
      final jsonMap = {
        'name': 'Artist Name',
        'popularity': 100,
        'image': 'https://example.com/image.jpg'
      };

      final artist = ArtistModel.fromJson(jsonMap);

      expect(artist.name, 'Artist Name');
      expect(artist.popularity, 100);
      expect(artist.image, 'https://example.com/image.jpg');
    });

    test('toJson should return a valid JSON map', () {
      final artist = ArtistModel(
        name: 'Artist Name',
        popularity: 100,
        image: 'https://example.com/image.jpg',
      );

      final jsonMap = artist.toJson();

      expect(jsonMap['name'], 'Artist Name');
      expect(jsonMap['popularity'], 100);
      expect(jsonMap['image'], 'https://example.com/image.jpg');
    });

    test('fromJsonList should return a list of ArtistModel objects', () {
      final jsonList = [
        {
          'name': 'Artist Name 1',
          'popularity': 100,
          'image': 'https://example.com/image1.jpg'
        },
        {
          'name': 'Artist Name 2',
          'popularity': 80,
          'image': 'https://example.com/image2.jpg'
        },
      ];

      final artists = ArtistModel.fromJsonList(jsonList);

      expect(artists.length, 2);
      expect(artists[0].name, 'Artist Name 1');
      expect(artists[0].popularity, 100);
      expect(artists[0].image, 'https://example.com/image1.jpg');
      expect(artists[1].name, 'Artist Name 2');
      expect(artists[1].popularity, 80);
      expect(artists[1].image, 'https://example.com/image2.jpg');
    });

    test('toJsonList should return a list of JSON maps', () {
      final artists = [
        ArtistModel(
          name: 'Artist Name 1',
          popularity: 100,
          image: 'https://example.com/image1.jpg',
        ),
        ArtistModel(
          name: 'Artist Name 2',
          popularity: 80,
          image: 'https://example.com/image2.jpg',
        ),
      ];

      final jsonList = ArtistModel.toJsonList(artists);

      expect(jsonList.length, 2);
      expect(jsonList[0]['name'], 'Artist Name 1');
      expect(jsonList[0]['popularity'], 100);
      expect(jsonList[0]['image'], 'https://example.com/image1.jpg');
      expect(jsonList[1]['name'], 'Artist Name 2');
      expect(jsonList[1]['popularity'], 80);
      expect(jsonList[1]['image'], 'https://example.com/image2.jpg');
    });

    test('artistModelFromJson should return a list of ArtistModel objects', () {
      const jsonString = '''
      [
        {"name": "Artist Name 1", "popularity": 100, "image": "https://example.com/image1.jpg"},
        {"name": "Artist Name 2", "popularity": 80, "image": "https://example.com/image2.jpg"}
      ]
      ''';

      final artists = artistModelFromJson(jsonString);

      expect(artists.length, 2);
      expect(artists[0].name, 'Artist Name 1');
      expect(artists[0].popularity, 100);
      expect(artists[0].image, 'https://example.com/image1.jpg');
      expect(artists[1].name, 'Artist Name 2');
      expect(artists[1].popularity, 80);
      expect(artists[1].image, 'https://example.com/image2.jpg');
    });

    test('artistModelToJson should return a valid JSON string', () {
      final artists = [
        ArtistModel(
          name: 'Artist Name 1',
          popularity: 100,
          image: 'https://example.com/image1.jpg',
        ),
        ArtistModel(
          name: 'Artist Name 2',
          popularity: 80,
          image: 'https://example.com/image2.jpg',
        ),
      ];

      final jsonString = artistModelToJson(artists);
      final jsonData = json.decode(jsonString);

      expect(jsonData.length, 2);
      expect(jsonData[0]['name'], 'Artist Name 1');
      expect(jsonData[0]['popularity'], 100);
      expect(jsonData[0]['image'], 'https://example.com/image1.jpg');
      expect(jsonData[1]['name'], 'Artist Name 2');
      expect(jsonData[1]['popularity'], 80);
      expect(jsonData[1]['image'], 'https://example.com/image2.jpg');
    });
  });
}
