// lib/api_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/api_endpoints.dart';
import 'package:spotify_app_poc/repository/pagination_params.dart';
import 'package:spotify_app_poc/utils/constants.dart';

class ApiService {
  final http.Client client;
  ApiService(this.client);

  Future<List<ArtistModel>> searchArtists({
    required String query,
    required String token,
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    var endPoint = '${ApiEndpoints.baseUrl}${ApiEndpoints.search}';
    var searchType = 'type=artist';

    final url = Uri.parse(
        '$endPoint?q=$query&$searchType&offset=${paginationParams.offset}&limit=${paginationParams.limit}');
    var response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var items = result['artists']['items'] as List;

      var artists = items.map((item) {
        List images = item['images'];
        return ArtistModel(
          name: item['name'],
          popularity: item['popularity'],
          image: images.isEmpty ? 'no url' : images[0]['url'],
        );
      }).toList();

      return artists;
    }
    throw Exception('${response.statusCode}');
  }

  Future<List<Item>> albumList({
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    try {
      final url = Uri.parse(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.newReleases}?limit=${paginationParams.limit}&offset=${paginationParams.offset}',
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
      } else if (response.statusCode == 400) {
        throw Exception('Data Not Found');
      }
    } catch (e) {
      print('Unable to load the data due to :$e');
    }
    throw Exception('error');
  }
}
