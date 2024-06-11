import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReusableCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onIconPressed;

  const ReusableCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.deepPurple[100],
        margin: const EdgeInsets.all(10.0),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://homestaymatch.com/images/no-image-available.png',
              imageBuilder: (context, imageProvider) => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 60,
              height: 60,
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.purpleAccent,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.music_note),
              iconSize: 30,
              color: Colors.blue,
              onPressed: onIconPressed,
            ),
          ),
        ),
      ),
    );
  }
}
