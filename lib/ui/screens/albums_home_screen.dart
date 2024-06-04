import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_app_poc/blocs/bloc/album_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app_poc/repository/services.dart';
import 'package:spotify_app_poc/ui/screens/search_screen.dart';

// ignore_for_file: prefer_const_constructors

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  final TextEditingController _searchController = TextEditingController();
  late AlbumBloc albumBloc;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    albumBloc = AlbumBloc();
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
            child: Text('Spotify App'),
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
                        return InkWell(
                          onTap: () {
                            ApiService.albumList();
                          },
                          child: Column(
                            children: [
                              Card(
                                color: Colors.deepPurple[100],
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  height: 80,
                                  padding: EdgeInsets.all(10.0),
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: album.images.isNotEmpty
                                          ? album.images[0].url
                                          : "https://homestaymatch.com/images/no-image-available.png",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 60,
                                      height: 60,
                                    ),
                                    title: Text(
                                      album.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    subtitle: Text(
                                      album.artists
                                          .map((artist) => artist.name)
                                          .join(", "),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.music_note),
                                      iconSize: 30,
                                      color: Colors.blue,
                                      onPressed: () {
                                        print('Music button pressed');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              if (albums.length - 1 == index)
                                CircularProgressIndicator(),
                            ],
                          ),
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
