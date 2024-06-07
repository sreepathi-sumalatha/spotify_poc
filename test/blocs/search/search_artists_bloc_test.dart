import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/services.dart';

import '../../stub_responses/read_response.dart';
import 'search_artists_bloc_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  final SearchArtistsBloc searchArtistsBloc;
  late ApiService apiService;

  setUp(() {
    apiService = ApiService(Client());
  });

  tearDown(() {});

  group('SearchArtistsBloc', () {
    // test('initial state is SearchArtistsInitial', () {
    //   expect(searchArtistsBloc.state, SearchArtistsInitial());
    // });

    blocTest<SearchArtistsBloc, SearchArtistsState>(
        'emits [SearchArtistQueryLoadingState, SearchArtistQuerySuccessState] when search is successful',
        build: () {
          var stub = fixture('search_artists_response.json');
          when(apiService.searchArtists(
            query: anyNamed('query').toString(),
            token: anyNamed('token').toString(),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async {
            var result = jsonDecode(stub)['artists']['items'] as List;
            return result.map((item) {
              var images = item['images'] as List;
              return ArtistModel(
                name: item['name'],
                popularity: item['popularity'],
                image: images.isEmpty ? 'no url' : images[0]['url'],
              );
            }).toList();
          });
          return;
        },
        act: (bloc) => bloc.add(SearchArtistsByQueryEvent('query')),
        expect: () => [
              isA<SearchArtistQueryLoadingState>(),
              isA<SearchArtistQueryLoadingState>(),
            ]
        // expect: () => (isA <SearchArtistQueryLoadingState()>);
        // expect: () => [
        //   SearchArtistQueryLoadingState(),
        //   isA<SearchArtistQueryLoadingState>().having((state) => state.artists, 'artists', isNotEmpty),
        // ],
        );

    blocTest<SearchArtistsBloc, SearchArtistsState>(
      'emits [SearchArtistQueryLoadingState, SearchArtistQueryErrorState] when search fails',
      build: () {
        when(apiService.searchArtists(
          query: anyNamed('query').toString(),
          token: anyNamed('token').toString(),
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        )).thenThrow(Exception('API call failed'));
        return searchArtistsBloc;
      },
      act: (bloc) => bloc.add(SearchArtistsByQueryEvent('query')),
      expect: () => [
        SearchArtistQueryLoadingState(),
        SearchArtistQueryErrorState(),
      ],
    );

    blocTest<SearchArtistsBloc, SearchArtistsState>(
      'emits [SearchArtistQuerySuccessState] with additional artists when load more is successful',
      build: () {
        var initialStub = fixture("search_artists_response.json");
        var loadMoreStub = fixture("search_artists_response.json");

        when(apiService.searchArtists(
          query: anyNamed('query'),
          token: anyNamed('token'),
          offset: 0,
          limit: 20,
        )).thenAnswer((_) async {
          var result = jsonDecode(initialStub)['artists']['items'] as List;
          return result.map((item) {
            var images = item['images'] as List;
            return ArtistModel(
              name: item['name'],
              popularity: item['popularity'],
              image: images.isEmpty ? 'no url' : images[0]['url'],
            );
          }).toList();
        });

        when(apiService.searchArtists(
          query: anyNamed('query'),
          token: anyNamed('token'),
          offset: 20,
          limit: 20,
        )).thenAnswer((_) async {
          var result = jsonDecode(loadMoreStub)['artists']['items'] as List;
          return result.map((item) {
            var images = item['images'] as List;
            return ArtistModel(
              name: item['name'],
              popularity: item['popularity'],
              image: images.isEmpty ? 'no url' : images[0]['url'],
            );
          }).toList();
        });

        return searchArtistsBloc;
      },
      act: (bloc) async {
        bloc.add(SearchArtistsByQueryEvent('query'));
        await Future.delayed(Duration.zero); // Let the first event process
        bloc.add(LoadMoreArtistsEvent());
      },
      expect: () => [
        SearchArtistQueryLoadingState(),
        isA<SearchArtistQuerySuccessState>()
            .having((state) => state.artists, 'artists', isNotEmpty),
        isA<SearchArtistQuerySuccessState>().having(
            (state) => state.artists.length, 'artists length', greaterThan(20)),
      ],
    );
  });
}
