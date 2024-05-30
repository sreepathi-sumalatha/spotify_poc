import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotify_app_poc/models/album_model.dart';

class ApiService {
  static Future albumList() async {
    try {
      final url = Uri.parse(
          "https://api.spotify.com/v1/browse/new-releases?limit=10&offset=1");
      // Bearer token expires within 1 hr please replace if data not load.
      Response response = await http.get(url, headers: {
        'Authorization':
            'Bearer BQBSLnw1j5HOx6JzcRxFZJQsccjOgCNyVsFG5Llj836kBlFICs7XSFC4Xt0b53IdSgsprBe5O7hJEVnBMg0KzrJFqtQQn1Lm3ePQCfo4edojeu_ihEw'
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        var result = Album.fromJson(jsonData);
        print(result.albums.toJson());
      } else if (response.statusCode == 400) {
        throw Exception("Data Not Found");
      }
    } catch (e) {
      print("Unable to load the data due to :$e");
    }
  }
}
