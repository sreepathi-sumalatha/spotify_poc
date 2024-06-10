import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/services.dart';

import '../stub_responses/read_response.dart';
import 'services_test.mocks.dart';

@GenerateMocks([BaseClient])
void main() {
  var mockClient = MockBaseClient();
  var apiService = ApiService(mockClient);

  group('SerachArtists, Albums succcess and failure  test senarios', () {
    test('When  api returns success then return List of Artists Data',
        () async {
      var stub = fixture(
          'search_artists_response.json'); // it will feed the stub response
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(stub, 200));
      var result =
          await apiService.searchArtists(query: 'query', token: 'token');

      expect(result, isA<List<ArtistModel>>());
    });

    test('When API returns failure then throw exception', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('Not Found', 404));

      expect(
        () async =>
            await apiService.searchArtists(query: 'query', token: 'token'),
        throwsA(isA<Exception>()),
      );
    });
  });
// test cases for the  fetch album data
  test('When  api returns success then return List of album Data', () async {
    var stub = fixture('albums_response.json');
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(stub, 200));
    var result = await apiService.albumList();

    expect(result, isA<List<Item>>());
  });
  test('When API returns failure then throw exception', () async {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('Not Found', 404));
    var items = await apiService.albumList();
    expect(items, isEmpty);
    //  expect(() async => await apiService.albumList(), throwsException);
  });

  test('returns an empty list if an exception is thrown', () async {
    when(mockClient.get(
      any,
      headers: anyNamed('headers'),
    )).thenThrow(Exception('Network error'));

    var items = await apiService.albumList();
    expect(items, isEmpty);
  });
}
