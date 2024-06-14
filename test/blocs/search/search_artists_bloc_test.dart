import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';

import 'search_artists_bloc_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockRepo = MockApiService();
  late SearchArtistsBloc bloc;

  setUp(() {
    bloc = SearchArtistsBloc(mockRepo);
  });

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
        paginationParams: anyNamed('paginationParams'),
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
          paginationParams: anyNamed('paginationParams'),
        )).thenThrow(Exception('error'));
      },
      act: (bloc) => bloc.add(SearchArtistsByQueryEvent('query')),
      expect: () => [
        isA<SearchArtistQueryLoadingState>(),
        isA<SearchArtistQueryErrorState>(),
      ],
    );
  });

  group('when LoadMoreArtistsEvent is added: ', () {
    blocTest<SearchArtistsBloc, SearchArtistsState>(
      'does not emit new states if already loading more artists',
      build: () => bloc,
      setUp: () {
        bloc.isLoadingMore = true;
      },
      act: (bloc) => bloc.add(LoadMoreArtistsEvent()),
      expect: () => [],
    );

    blocTest<SearchArtistsBloc, SearchArtistsState>(
      'emits SearchArtistQueryErrorState if repo call fails while loading more data',
      build: () {
        when(mockRepo.searchArtists(
          query: anyNamed('query'),
          token: anyNamed('token'),
          paginationParams: anyNamed('paginationParams'),
        )).thenThrow(Exception('error'));
        bloc.emit(
            SearchArtistQuerySuccessState(mockResponse, hasReachedEnd: false));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMoreArtistsEvent()),
      expect: () => [
        isA<SearchArtistQueryErrorState>()
            .having((state) => state.error, 'error', 'Exception: error'),
      ],
    );
  });
}
