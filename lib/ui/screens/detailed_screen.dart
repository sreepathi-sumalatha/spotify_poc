import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_app_poc/models/album_model.dart';
// ignore_for_file: prefer_const_constructors

class AlbumDetailedScreen extends StatelessWidget {
  final Item album;

  const AlbumDetailedScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          album.name.length > 10
              ? '${album.name.substring(0, 10)}...'
              : album.name,
          style: TextStyle(color: Colors.purple),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: album.images.isNotEmpty
                    ? album.images[0].url
                    : 'https://homestaymatch.com/images/no-image-available.png',
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              album.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Artist(s): ${album.artists.map((artist) => artist.name).join(", ")}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.purpleAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
