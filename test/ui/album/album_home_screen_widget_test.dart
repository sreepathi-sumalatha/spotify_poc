import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/ui/screens/album/album_detailed_screen.dart';
import 'package:spotify_app_poc/ui/screens/album/albums_home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});
  tearDown(() {});

  Widget getWidget() {
    return const MaterialApp(home: AlbumList());
  }

  testWidgets('Albums home screen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      getWidget(),
    );
  });
}
