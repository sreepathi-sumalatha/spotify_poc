import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';
import 'package:spotify_app_poc/repository/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app_poc/ui/screens/search_artists_ui/search_artists_screen.dart';

import '../../blocs/search/search_artists_bloc_test.mocks.dart';
import '../../stub_responses/read_response.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late SearchArtistsBloc searchArtistsBloc;

  setUp(() {
    mockApiService = MockApiService();
    searchArtistsBloc = SearchArtistsBloc()..apiService = mockApiService;
  });

  tearDown(() {
    searchArtistsBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (context) => searchArtistsBloc,
          child: SearchScreen(),
        ),
      ),
    );
  }

  group('SearchScreen', () {
    testWidgets('displays initial state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Please enter a search query...'), findsOneWidget);
    });

    testWidgets('displays loading indicator when search is in progress',
        (WidgetTester tester) async {
      when(mockApiService.searchArtists(
        query: anyNamed('query'),
        token: anyNamed('token'),
        offset: anyNamed('offset'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => []);

      searchArtistsBloc.add(SearchArtistsByQueryEvent('query'));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(); // Rebuilds the widget with the loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays search results when search is successful',
        (WidgetTester tester) async {
      var stub = fixture("search_artists_response.json");
      var result = jsonDecode(stub)['artists']['items'] as List;
      var artistData = result.map((item) {
        var images = item['images'] as List;
        return ArtistModel(
          name: item['name'],
          popularity: item['popularity'],
          image: images.isEmpty ? 'no url' : images[0]['url'],
        );
      }).toList();

      when(mockApiService.searchArtists(
        query: anyNamed('query'),
        token: anyNamed('token'),
        offset: anyNamed('offset'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => artistData);

      searchArtistsBloc.add(SearchArtistsByQueryEvent('query'));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(); // Rebuilds the widget with the loading state
      await tester.pump(); // Rebuilds the widget with the success state

      expect(find.text('Please enter a search query...'), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('displays error message when search fails',
        (WidgetTester tester) async {
      when(mockApiService.searchArtists(
        query: anyNamed('query'),
        token: anyNamed('token'),
        offset: anyNamed('offset'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception('API call failed'));

      searchArtistsBloc.add(SearchArtistsByQueryEvent('query'));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(); // Rebuilds the widget with the loading state
      await tester.pump(); // Rebuilds the widget with the error state

      expect(find.text('There is an error'), findsOneWidget);
    });

    testWidgets('displays additional artists when loading more is successful',
        (WidgetTester tester) async {
      var initialStub = fixture("search_artists_response.json");
      var loadMoreStub = fixture("search_artists_response.json");

      var initialResult = jsonDecode(initialStub)['artists']['items'] as List;
      var additionalResult =
          jsonDecode(loadMoreStub)['artists']['items'] as List;

      var initialArtistData = initialResult.map((item) {
        var images = item['images'] as List;
        return ArtistModel(
          name: item['name'],
          popularity: item['popularity'],
          image: images.isEmpty ? 'no url' : images[0]['url'],
        );
      }).toList();

      var additionalArtistData = additionalResult.map((item) {
        var images = item['images'] as List;
        return ArtistModel(
          name: item['name'],
          popularity: item['popularity'],
          image: images.isEmpty ? 'no url' : images[0]['url'],
        );
      }).toList();

      when(mockApiService.searchArtists(
        query: anyNamed('query'),
        token: anyNamed('token'),
        offset: 0,
        limit: 20,
      )).thenAnswer((_) async => initialArtistData);

      when(mockApiService.searchArtists(
        query: anyNamed('query'),
        token: anyNamed('token'),
        offset: 20,
        limit: 20,
      )).thenAnswer((_) async => additionalArtistData);

      searchArtistsBloc.add(SearchArtistsByQueryEvent('query'));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(); // Rebuilds the widget with the initial loading state
      await tester.pump(); // Rebuilds the widget with the initial success state

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);

      searchArtistsBloc.add(LoadMoreArtistsEvent());
      await tester.pump(); // Rebuilds the widget with the loading more state
      await tester
          .pump(); // Rebuilds the widget with the success state with additional artists

      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
