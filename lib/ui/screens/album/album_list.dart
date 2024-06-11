import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:spotify_app_poc/blocs/album/album_bloc.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';
import 'package:spotify_app_poc/ui/screens/album/album_detailed_screen.dart';
import 'package:spotify_app_poc/ui/screens/album/reusable_card.dart';
import 'package:spotify_app_poc/ui/screens/search_artists_ui/search_artists_screen.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  final TextEditingController _searchController = TextEditingController();
  late final AlbumBloc albumBloc;
  late final ApiService apiService;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Client());
    albumBloc = AlbumBloc(apiService);
    albumBloc.add(AlbumFetchEvent());
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          albumBloc.add(LoadMoreAlbumEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    albumBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => albumBloc,
      child: Scaffold(
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
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search here...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
            Expanded(
              child: BlocBuilder<AlbumBloc, AlbumState>(
                bloc: albumBloc,
                builder: (context, state) {
                  if (state is AlbumLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is AlbumSuccessesState) {
                    var albums = state.albumDataList;
                    return ListView.builder(
                      controller: _controller,
                      itemCount: albums?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        var album = albums![index];
                        return Column(
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
                              CircularProgressIndicator(),
                          ],
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
