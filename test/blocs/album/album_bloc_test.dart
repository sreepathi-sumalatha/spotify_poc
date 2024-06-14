import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';

import '../search/search_artists_bloc_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  TestWidgetsFlutterBinding
      .ensureInitialized(); // It provides the testing environment for the all fluttere tests

  late MockApiService
      mockApiService; // We initialize MockApiService and inject it into albumBloc.
  final mockRepo = MockApiService();
  late AlbumBloc albumBloc;

  setUp(() {
    mockApiService = MockApiService();
    albumBloc = AlbumBloc(mockRepo);
  });
// below test case can be optional at empty records expectations.
  blocTest<AlbumBloc, AlbumState>(
    'emits [] when nothing is added',
    build: () => albumBloc,
    expect: () => [],
  );
  final List<Item> mockAlbumResponse = [
    Item(name: 'Album 1', artists: [], images: []),
    Item(name: 'Album 2', artists: [], images: []),
  ];

  group('AlbumFetchEvent is added', () {
    blocTest<AlbumBloc, AlbumState>(
      'emits AlbumSuccessesState if repo call is successful',
      build: () {
        when(mockRepo.albumList()).thenAnswer((_) async => mockAlbumResponse);
        return albumBloc;
      },
      act: (bloc) => bloc.add(AlbumFetchEvent()),
      expect: () => [
        isA<AlbumLoadingState>(),
        // isA<>.having method to check for AlbumSuccessesState and ensure the albumDataList property matches mockAlbumResponse.

        isA<AlbumSuccessesState>().having(
            (state) => state.albumDataList, 'albumDataList', mockAlbumResponse),
      ],
    );

    blocTest<AlbumBloc, AlbumState>(
      'emits AlbumErrorState if repo call is fails',
      build: () {
        when(mockRepo.albumList())
            .thenThrow(Exception('Error at fetching albums'));
        return albumBloc;
      },
      act: (bloc) => bloc.add(AlbumFetchEvent()),
      expect: () => [
        isA<AlbumLoadingState>(),
        isA<AlbumErrorState>().having((state) => state.error, 'error',
            'Exception: Error at fetching albums'),
      ],
    );
  });

  blocTest<AlbumBloc, AlbumState>(
    'emits AlbumErrorState if repo call fails while loading more data',
    build: () {
      when(mockRepo.albumList())
          .thenThrow(Exception('Error at fetching more albums'));
      albumBloc.emit(AlbumSuccessesState(albumDataList: mockAlbumResponse));
      return albumBloc;
    },
    act: (bloc) => bloc.add(LoadMoreAlbumEvent()),
    expect: () => [
      isA<AlbumErrorState>().having((state) => state.error, 'error',
          'Exception: Error at fetching more albums'),
    ],
  );
}
