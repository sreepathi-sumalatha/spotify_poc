import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';

@GenerateMocks([BaseClient])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AlbumBloc bloc;
  group('Artists bloc test cases', () {});
}

MockApiService() {}
