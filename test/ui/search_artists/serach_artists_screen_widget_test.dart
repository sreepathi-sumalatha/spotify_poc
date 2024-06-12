import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';
import 'package:spotify_app_poc/ui/screens/search_artists_ui/search_artists_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app_poc/ui/screens/album/reusable_card.dart';

class MockSearchArtistsBloc
    extends MockBloc<SearchArtistsEvent, SearchArtistsState>
    implements SearchArtistsBloc {}

class MockApiService extends Mock implements ApiService {}

class FakeSearchArtistsEvent extends Fake implements SearchArtistsEvent {}

class FakeSearchArtistsState extends Fake implements SearchArtistsState {}

void main() {
  late MockSearchArtistsBloc mockSearchArtistsBloc;
  late MockApiService mockApiService;

  setUpAll(() {
    registerFallbackValue(FakeSearchArtistsEvent());
    registerFallbackValue(FakeSearchArtistsState());
  });

  setUp(() {
    mockSearchArtistsBloc = MockSearchArtistsBloc();
    mockApiService = MockApiService();
  });

  tearDown(() {
    mockSearchArtistsBloc.close();
  });

  Widget searchWidgetTest() {
    return MaterialApp(
      home: BlocProvider<SearchArtistsBloc>(
        create: (context) => mockSearchArtistsBloc,
        child: const SearchScreen(),
      ),
    );
  }

  group('SearchScreen', () {
    testWidgets('renders AppBar and TextField', (WidgetTester tester) async {
      await tester.pumpWidget(searchWidgetTest());

      // Check for AppBar title
      expect(find.text('Search '), findsOneWidget);

      // Check for TextField
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator when state is SearchArtistQueryLoadingState',
        (WidgetTester tester) async {
      when(() => mockSearchArtistsBloc.state)
          .thenReturn(SearchArtistQueryLoadingState());

      await tester.pumpWidget(searchWidgetTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders list of artists when state is SearchArtistQuerySuccessState',
        (WidgetTester tester) async {
      final artists = [
        ArtistModel(
            name: 'Artist 1',
            popularity: 90,
            image: 'https://example.com/artist1.jpg'),
        ArtistModel(
            name: 'Artist 2',
            popularity: 80,
            image: 'https://example.com/artist2.jpg'),
      ];
      when(() => mockSearchArtistsBloc.state).thenReturn(
          SearchArtistQuerySuccessState(artists, hasReachedEnd: true));

      await tester.pumpWidget(searchWidgetTest());
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ReusableCard), findsNWidgets(2));
    });

    testWidgets(
        'renders error message when state is SearchArtistQueryErrorState',
        (WidgetTester tester) async {
      when(() => mockSearchArtistsBloc.state)
          .thenReturn(SearchArtistQueryErrorState());

      await tester.pumpWidget(searchWidgetTest());
      expect(find.text('There is an error'), findsOneWidget);
    });

    testWidgets('renders prompt for search query when state is initial',
        (WidgetTester tester) async {
      when(() => mockSearchArtistsBloc.state)
          .thenReturn(SearchArtistsInitial());

      await tester.pumpWidget(searchWidgetTest());
      expect(find.text('Please enter a search query...'), findsOneWidget);
    });

    testWidgets('Tapping the TextField triggers SearchArtistsByQueryEvent',
        (WidgetTester tester) async {
      await tester.pumpWidget(searchWidgetTest());

      await tester.enterText(find.byType(TextField), 'Test Query');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(() => mockSearchArtistsBloc
          .add(SearchArtistsByQueryEvent('Test Query'))).called(1);
    });
  });
}
