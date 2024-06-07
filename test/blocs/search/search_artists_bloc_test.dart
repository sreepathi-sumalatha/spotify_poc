import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';

import '../album/album_bloc_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockRepo = MockApiService();
  late SearchArtistsBloc bloc;

  setUp(() {
    bloc = SearchArtistsBloc(mockRepo);
  });

  blocTest(
    'emits [] when nothing is added',
    build: () => bloc,
    expect: () => [],
  );
  final List<ArtistModel> mockResponse = [
    ArtistModel(name: 'Artist 1', popularity: 80, image: 'url1'),
    ArtistModel(name: 'Artist 2', popularity: 75, image: 'url2')
  ];
  group('when SearchArtistsByQueryEvent is added: ', () {
    mockCall() => mockRepo.searchArtists(
          query: anyNamed('query'),
          token: anyNamed('token'),
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        );
    blocTest(
      'emits SearchArtistQuerySuccessState if repo call is successful',
      build: () => bloc,
      setUp: () {
        when(mockCall()).thenAnswer(
          (_) async => mockResponse,
        );
      },
      act: (SearchArtistsBloc bloc) =>
          bloc.add(SearchArtistsByQueryEvent('query')),
      expect: () => [
        isA<SearchArtistQueryLoadingState>(),
        isA<SearchArtistQuerySuccessState>(),
      ],
    );
    blocTest(
      'emits SearchArtistQueryErrorState if repo call is fails',
      build: () => bloc,
      setUp: () {
        when(mockCall()).thenThrow(Exception('error '));
      },
      act: (SearchArtistsBloc bloc) =>
          bloc.add(SearchArtistsByQueryEvent('query')),
      expect: () => [
        isA<SearchArtistQueryLoadingState>(),
        isA<SearchArtistQueryErrorState>(),
      ],
    );
  });
}
