import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';

void main() {
  test('Convert JSON string to list of items', () {
    const jsonString = '''
    [
      {
        "name": "Item1",
        "artists": [{"name": "Artist1"}],
        "images": [{"url": "http://image1.com"}]
      },
      {
        "name": "Item2",
        "artists": [{"name": "Artist2"}],
        "images": [{"url": "http://image2.com"}]
      }
    ]
    ''';

    final items = itemsFromJson(jsonString);

    expect(items.length, 2);
    expect(items[0].name, 'Item1');
    expect(items[0].artists[0].name, 'Artist1');
    expect(items[0].images[0].url, 'http://image1.com');
  });

  test('Item.fromJson', () {
    const jsonMap = {
      'name': 'Item1',
      'artists': [
        {'name': 'Artist1'}
      ],
      'images': [
        {'url': 'http://image1.com'}
      ]
    };

    final item = Item.fromJson(jsonMap);

    expect(item.name, 'Item1');
    expect(item.artists[0].name, 'Artist1');
    expect(item.images[0].url, 'http://image1.com');
  });

  test('Item.toJson', () {
    final item = Item(
      name: 'Item1',
      artists: [Artist(name: 'Artist1')],
      images: [Image(url: 'http://image1.com')],
    );

    final jsonMap = item.toJson();

    expect(jsonMap['name'], 'Item1');
    expect(jsonMap['artists'][0]['name'], 'Artist1');
    expect(jsonMap['images'][0]['url'], 'http://image1.com');
  });

  test('Artist.fromJson', () {
    const jsonMap = {"name": "Artist1"};

    final artist = Artist.fromJson(jsonMap);

    expect(artist.name, 'Artist1');
  });

  test('Artist.toJson', () {
    final artist = Artist(name: 'Artist1');

    final jsonMap = artist.toJson();

    expect(jsonMap['name'], 'Artist1');
  });

  test('Image.fromJson', () {
    const jsonMap = {"url": "http://image1.com"};

    final image = Image.fromJson(jsonMap);

    expect(image.url, 'http://image1.com');
  });

  test('Image.toJson', () {
    final image = Image(url: 'http://image1.com');

    final jsonMap = image.toJson();

    expect(jsonMap['url'], 'http://image1.com');
  });
}
