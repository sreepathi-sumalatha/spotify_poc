import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotify_app_poc/models/album_model.dart';

class ApiService {
  static Future albumList() async {
    try {
      final url = Uri.parse(
        "https://api.spotify.com/v1/browse/new-releases?limit=20&offset=1",
      );
      // Bearer token expires within 1 hr please replace if data not load.
      String token =
          'BQDnLnSEN-oYin60YMvZWnXgfMoVPjSr0wKhw7J4F0dZtzs-BsvwLIkLk2TS22kLu0d3-8MJ7mTdYHo2G6nln1a6GTphrswKA6hpxl7rnQDAfzCtqm0';

      Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      // print(response.body);
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
