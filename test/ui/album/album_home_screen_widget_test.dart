import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';
import 'package:spotify_app_poc/ui/screens/album/album_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAlbumBloc extends MockBloc<AlbumEvent, AlbumState>
    implements AlbumBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAlbumBloc mockAlbumBloc;

  setUp(() {
    mockAlbumBloc = MockAlbumBloc();
  });

  tearDown(() {
    mockAlbumBloc.close();
  });

  Widget albumWidgetTest() {
    return MaterialApp(
      home: BlocProvider<AlbumBloc>(
        create: (context) => mockAlbumBloc,
        child: const AlbumList(),
      ),
    );
  }

  testWidgets('title and text fields checking', (WidgetTester tester) async {
    await tester.pumpWidget(albumWidgetTest());

    expect(find.text('Spotify App'), findsOneWidget); // checking the title
    expect(find.byType(TextField), findsOneWidget);
  });
}
