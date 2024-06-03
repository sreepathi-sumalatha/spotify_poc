import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotify_app_poc/blocs/bloc/album_bloc.dart';
import 'package:spotify_app_poc/models/album_model.dart';
import 'package:spotify_app_poc/models/artist_model.dart';

class ApiService {
  static Future<List<ArtistModel>> searchArtists(
      {required String query, required String token}) async {
    List<ArtistModel> artists = [];

    var baseUrl = 'https://api.spotify.com/v1';
    var endPoint = '$baseUrl/search';
    var searchType = 'type=artist';
    //  headers: {'Authorization': 'Bearer $token'};

    final url = Uri.parse('$endPoint?q=$query&$searchType');
    var response = await http.get(
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
          image: images.isEmpty ? "no url" : images[0]['url'],
        );
        artists.add(artist);
      }
      return artists;
    }
    throw Exception("${response.statusCode}");
  }

  static Future albumList() async {
    try {
      final url = Uri.parse(
        "https://api.spotify.com/v1/browse/new-releases?limit=20&offset=1",
      );
      // Bearer token expires within 1 hr please replace if data not load.
      String token =
          'BQBQ2uRlpVsaM0yyjCK6H4JC0iMYD2ZlyGcJC8rHp60dwOlpmyN4juqS8cPi4QSDOWU1foXOJoDldYZDbzU5H_LE1DHfNQOoWRxeXnVXxvSmbjHfCpk';

      Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // var result = Item.fromJson(jsonData);
        var result = Album.fromJson(jsonData);
        // print('name ${result.albums.items.map((e) => e.name)}');
        return result.albums.items;
      } else if (response.statusCode == 400) {
        throw Exception("Data Not Found");
      }
    } catch (e) {
      print("Unable to load the data due to :$e");
    }
  }
}
