import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/services.dart';

import 'search_artists_bloc_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockRepo = MockApiService();
  late SearchArtistsBloc bloc;

  setUp(() {
    bloc = SearchArtistsBloc(mockRepo);
  });
// this test senarios is optinal for the  empty senarios.
  blocTest<SearchArtistsBloc, SearchArtistsState>(
    'emits [] when nothing is added',
    build: () => bloc,
    expect: () => [],
  );

  final List<ArtistModel> mockResponse = [
    ArtistModel(name: 'Artist 1', popularity: 80, image: 'url1'),
    ArtistModel(name: 'Artist 2', popularity: 75, image: 'url2'),
  ];

  group('when SearchArtistsByQueryEvent is added: ', () {
    setUp(() {
      when(mockRepo.searchArtists(
        query: anyNamed('query'),
        token: anyNamed('token'),
        offset: anyNamed('offset'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => mockResponse);
    });

    blocTest<SearchArtistsBloc, SearchArtistsState>(
      'emits SearchArtistQuerySuccessState if repo call is successful',
      build: () => bloc,
      act: (bloc) => bloc.add(SearchArtistsByQueryEvent('query')),
      expect: () => [
        isA<SearchArtistQueryLoadingState>(),
        isA<SearchArtistQuerySuccessState>(),
      ],
    );

    blocTest<SearchArtistsBloc, SearchArtistsState>(
      'emits SearchArtistQueryErrorState if repo call fails',
      build: () => bloc,
      setUp: () {
        when(mockRepo.searchArtists(
          query: anyNamed('query'),
          token: anyNamed('token'),
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        )).thenThrow(Exception('error'));
      },
      act: (bloc) => bloc.add(SearchArtistsByQueryEvent('query')),
      expect: () => [
        isA<SearchArtistQueryLoadingState>(),
        isA<SearchArtistQueryErrorState>(),
      ],
    );
  });
}
