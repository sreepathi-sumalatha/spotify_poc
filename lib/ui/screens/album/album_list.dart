import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';
import 'package:spotify_app_poc/ui/screens/album/album_detailed_screen.dart';
import 'package:spotify_app_poc/ui/screens/album/reusable_card.dart';
import 'package:spotify_app_poc/ui/screens/search_artists_ui/search_artists_screen.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({super.key});

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumBloc(ApiService(Client()))..add(AlbumFetchEvent()),
      child: const AlbumListView(),
    );
  }
}

class AlbumListView extends StatefulWidget {
  const AlbumListView({
    super.key,
  });

  @override
  State<AlbumListView> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
//  WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkIfScrollable();
//     });
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          BlocProvider.of<AlbumBloc>(context).add(LoadMoreAlbumEvent());
        }
      }
    });
  }

  void _checkIfScrollable() {
    // Check if the ScrollController has scrollable extent
    if (!(_controller.position.maxScrollExtent > 0)) {
      BlocProvider.of<AlbumBloc>(context).add(LoadMoreAlbumEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Spotify App',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchListScreen()),
                );
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search here...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: BlocBuilder<AlbumBloc, AlbumState>(
              builder: (context, state) {
                if (state is AlbumLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AlbumSuccessesState) {
                  var albums = state.albumDataList;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _checkIfScrollable();
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: albums?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      var album = albums![index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReusableCard(
                            imageUrl: album.images.isNotEmpty
                                ? album.images[0].url
                                : 'https://homestaymatch.com/images/no-image-available.png',
                            title: album.name,
                            subtitle: album.artists
                                .map((artist) => artist.name)
                                .join(', '),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AlbumDetailedScreen(album: album),
                                ),
                              );
                            },
                            onIconPressed: () {
                              print('Music button pressed');
                            },
                          ),
                          if (albums.length - 1 == index)
                            const CircularProgressIndicator(),
                        ],
                      );
                    },
                  );
                } else if (state is AlbumErrorState) {
                  return const Center(child: Text('something went wrong'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
