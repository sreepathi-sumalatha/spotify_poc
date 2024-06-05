
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/services.dart';

import '../stub_responses/read_response.dart';
import 'services_test.mocks.dart';


@GenerateMocks([BaseClient])
// class MockHttp extends Mock implements Client{
  
// }

void main() {
  var mockClient = MockBaseClient();
   var apiService = ApiService(mockClient);

  group('SerachArtists test senarios', () { 

//AAA-- Arrange the for my method
// actuval cal
//assert -- then you will verify what your expeted behavior either it may be succcess or failer
 test('When  api returns success then return List of Artists Data',() async {
    var stub =fixture("search_artists_response.json");
    when(mockClient.get(any)).thenAnswer((_) async =>
      Response(stub, 200));
   var result=  await apiService.searchArtists(query: 'query', token: 'token');

       expect(result, isA<List<ArtistModel>>());



  });
  test('When  api returns fails then return error data',(){
   



  });

  });
 
}
