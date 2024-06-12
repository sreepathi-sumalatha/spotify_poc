import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';
import 'package:spotify_app_poc/models/album/album_model.dart' as album_model;
import 'package:spotify_app_poc/repository/spotify_repository.dart';
import 'package:spotify_app_poc/ui/screens/album/album_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app_poc/ui/screens/album/reusable_card.dart';

import 'package:spotify_app_poc/ui/screens/search_artists_ui/search_artists_screen.dart';

class MockAlbumBloc extends MockBloc<AlbumEvent, AlbumState>
    implements AlbumBloc {}

class MockApiService extends Mock implements ApiService {}

class FakeAlbumEvent extends Fake implements AlbumEvent {}

class FakeAlbumState extends Fake implements AlbumState {}

void main() {
  late MockAlbumBloc mockAlbumBloc;
  late MockApiService mockApiService;

  setUpAll(() {
    registerFallbackValue(FakeAlbumEvent());
    registerFallbackValue(FakeAlbumState());
  });

  setUp(() {
    mockAlbumBloc = MockAlbumBloc();
    mockApiService = MockApiService();
  });

  tearDown(() {
    mockAlbumBloc.close();
  });

  Widget albumWidgetzTest() {
    return MaterialApp(
      home: BlocProvider<AlbumBloc>(
        create: (context) => mockAlbumBloc,
        child: const AlbumList(),
      ),
    );
  }

  testWidgets('AlbumList has AppBar and TextField',
      (WidgetTester tester) async {
    await tester.pumpWidget(albumWidgetzTest());

    // Check for AppBar title
    expect(find.text('Spotify App'), findsOneWidget);

    // Check for TextField
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Tapping the TextField navigates to SearchScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(albumWidgetzTest());

    // Tap the TextField
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    // Check if SearchScreen is pushed onto the Navigator stack
    expect(find.byType(SearchScreen), findsOneWidget);
  });

  group('AlbumList success and failure test case senarios', () {
    testWidgets(
        'renders CircularProgressIndicator when state is AlbumLoadingState',
        (tester) async {
      when(() => mockAlbumBloc.state).thenReturn(AlbumLoadingState());

      await tester.pumpWidget(albumWidgetzTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders list of albums when state is AlbumSuccessesState',
        (tester) async {
      final albums = [
        album_model.Item(
          name: 'Album 1',
          images: [],
          artists: [],
        ),
        album_model.Item(
          name: 'Album 2',
          images: [],
          artists: [],
        ),
      ];
      when(() => mockAlbumBloc.state)
          .thenReturn(AlbumSuccessesState(albumDataList: albums));

      await tester.pumpWidget(albumWidgetzTest());
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ReusableCard), findsNWidgets(2));
    });

    testWidgets('renders error message when state is AlbumErrorState',
        (tester) async {
      when(() => mockAlbumBloc.state).thenReturn(AlbumErrorState());

      await tester.pumpWidget(albumWidgetzTest());
      expect(find.text('Error loading albums'), findsOneWidget);
    });
  });
}
