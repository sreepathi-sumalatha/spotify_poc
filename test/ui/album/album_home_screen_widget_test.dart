import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/ui/screens/album/album_detailed_screen.dart';
import 'package:spotify_app_poc/ui/screens/album/albums_home_screen.dart';
import 'package:mockito/mockito.dart';


//  void main() {
// //   TestWidgetsFlutterBinding.ensureInitialized();
// //   setUp(() async {});
// //   tearDown(() {});

//   Widget getWidget() {
//     return const MaterialApp(home: AlbumList());
//   }

//   testWidgets('Albums home screen widget test', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       getWidget(),
//     );
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';
import 'package:spotify_app_poc/ui/screens/album/album_detailed_screen.dart';
import 'package:spotify_app_poc/ui/screens/search_artists_ui/search_artists_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  group('AlbumList Widget Tests', () {

    late AlbumBloc albumBloc;

    setUp(() {
      albumBloc = AlbumBloc();
    });

    tearDown(() {
      albumBloc.close();
    });

    testWidgets('AlbumList displays loading indicator initially',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AlbumBloc>(
            create: (context) => albumBloc,
            child: AlbumList(),
          ),
        ),
      );

      // Assert
      //expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AlbumList displays albums when loaded',
        (WidgetTester tester) async {
      // Arrange
      albumBloc.add(AlbumFetchEvent());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AlbumBloc>(
            create: (context) => albumBloc,
            child: AlbumList(),
          ),
        ),
      );

      // Simulate loading state
      albumBloc.emit(AlbumLoadingState());
      await tester.pump();

      // Simulate success state with mock data
      albumBloc.emit(AlbumSuccessesState(albumDataList: [
        // Album(
        //   name: 'Test Album',
        //   images: [ImageModel(url: 'https://example.com/image.jpg')],
        //   artists: [Artist(name: 'Test Artist')], albums: null,
        // ),
      ]));
      await tester.pump();

      // Assert
      expect(find.text('Test Album'), findsOneWidget);
      expect(find.text('Test Artist'), findsOneWidget);
    });

    testWidgets('AlbumList navigates to AlbumDetailedScreen on tap',
        (WidgetTester tester) async {
      // Arrange
      albumBloc.add(AlbumFetchEvent());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AlbumBloc>(
            create: (context) => albumBloc,
            child: AlbumList(),
          ),
        ),
      );

      // Simulate success state with mock data
      albumBloc.emit(AlbumSuccessesState(albumDataList: [
        // Album(
        //   name: 'Test Album',
        //   images: [ImageModel(url: 'https://example.com/image.jpg')],
        //   artists: [Artist(name: 'Test Artist')],
        // ),
      ]));
      await tester.pump();

      // Act
      await tester.tap(find.text('Test Album'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlbumDetailedScreen), findsOneWidget);
    });

    testWidgets('AlbumList navigates to SearchScreen on search field tap',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AlbumBloc>(
            create: (context) => albumBloc,
            child: AlbumList(),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SearchScreen), findsOneWidget);
    });
  });
}
