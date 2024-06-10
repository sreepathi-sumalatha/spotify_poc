import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/utils/constants.dart';

class ApiService {
  final http.Client client;
  ApiService(this.client);
  Future<List<ArtistModel>> searchArtists({
    required String query,
    required String token,
    int offset = 0,
    int limit = 20,
  }) async {
    List<ArtistModel> artists = [];

    var baseUrl = 'https://api.spotify.com/v1';
    var endPoint = '$baseUrl/search';
    var searchType = 'type=artist';

    final url =
        Uri.parse('$endPoint?q=$query&$searchType&offset=$offset&limit=$limit');
    var response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var items = result['artists']['items'];

      for (var item in items) {
        List images = item['images'];
        var artist = ArtistModel(
          name: item['name'],
          popularity: item['popularity'],
          image: images.isEmpty ? 'no url' : images[0]['url'],
        );
        artists.add(artist);
      }
      return artists;
    }
    throw Exception('${response.statusCode}');
  }

  Future<List<Item>> albumList({int limit = 8, int offset = 0}) async {
    try {
      final url = Uri.parse(
        'https://api.spotify.com/v1/browse/new-releases?limit=$limit&offset=$offset',
      );
      http.Response response = await client.get(
        url,
        headers: {'Authorization': 'Bearer ${Constants.token}'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        var itemsData = jsonData['albums']['items'] as List;
        var items = itemsData.map((e) => Item.fromJson(e)).toList();
        return items;
        // var result = Album.fromJson(jsonData);
        // return result.albums.items;
      } else if (response.statusCode == 400) {
        throw Exception('Data Not Found');
      }
    } catch (e) {
      print('Unable to load the data due to :$e');
    }
    throw Exception('error');
  }
}
