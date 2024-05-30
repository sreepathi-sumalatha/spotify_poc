import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_app_poc/blocs/bloc/album_bloc.dart';
import 'package:spotify_app_poc/repository/album_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore_for_file: prefer_const_constructors

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  TextEditingController _searchController = TextEditingController();
  AlbumBloc albumBloc = AlbumBloc();

  @override
  void initState() {
    super.initState();
    // for checking purpose added
    ApiService.albumList();
    albumBloc = AlbumBloc();
    albumBloc.add(AlbumFetchEvent());
  }
// need to add later below code.
  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumBloc(),
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
                  ApiService.albumList();
                },
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search here...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            BlocBuilder<AlbumBloc, AlbumState>(
              bloc: albumBloc,
              builder: (context, state) {
                if (state is AlbumLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AlbumSuccessesState) {
                  var albums = state.albumDataList;
                  return ListView.builder(
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          ApiService.albumList();
                        },
                        child: Card(
                          color: Colors.deepPurple[100],
                          margin: EdgeInsets.all(10.0),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl:
                                    "https://homestaymatch.com/images/no-image-available.png",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              ),
                              title: Text(
                                // need to map the data
                                "Album name",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              subtitle: Text(
                                //need to map the data
                                "Artist Album",
                                style: TextStyle(
                                  fontSize: 18,
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
                      );
                    },
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
