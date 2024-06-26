import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/ui/screens/album/album_detailed_screen.dart';

void main() {
  //This line initializes the Flutter framework for testing widgets
  TestWidgetsFlutterBinding.ensureInitialized();
  //This line defines a setup function that's executed before each test case.
  setUp(() async {});
//This line defines a teardown function that's executed after each test case.
  tearDown(() {});

  Widget getWidget() {
    return MaterialApp(
        home: AlbumDetailedScreen(
      album: Item(name: '', artists: [], images: []),
    ));
  }

  testWidgets('Albums detailed screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      getWidget(),
    );

    // Pump the widget again to apply changes (if any)
    await tester.pump();

    var finder = find.byType(AppBar);

    expect(finder, findsOneWidget);

    var finder1 = find.byType(CachedNetworkImage);
    expect(finder1, findsOneWidget);

    await tester.tap(finder1);
  });
}
