import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app_poc/bloc/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/bloc/album_bloc.dart';
// ignore_for_file: prefer_const_constructors

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchArtistsBloc artistBloc;
  final _controller = ScrollController();
  late AlbumBloc albumBloc;

  @override
  void initState() {
    super.initState();
    albumBloc = AlbumBloc();
    albumBloc.add(AlbumFetchEvent());
    artistBloc = SearchArtistsBloc();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          artistBloc.add(LoadMoreArtistsEvent());
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
      create: (context) => SearchArtistsBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Search ')),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    log(query);
                    BlocProvider.of<SearchArtistsBloc>(context)
                        .add(SearchArtistsByQueryEvent(query));
                  },
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
                SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<SearchArtistsBloc, SearchArtistsState>(
                    builder: (context, state) {
                      log("State as $state");
                      if (state is SearchArtistQueryLoadingState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is SearchArtistQuerySuccessState) {
                        log("${state.artists.length}");

                        return ListView.builder(
                          controller: _controller,
                          itemCount: state.artists.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: state.artists[index].image.isEmpty
                                      ? "https://homestaymatch.com/images/no-image-available.png"
                                      : state.artists[index].image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
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
                                // title: Text(state.artists[index].name),
                                title: Text(
                                  state.artists[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                subtitle: Text(
                                  state.artists[index].popularity.toString(),
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
                            );
                          },
                        );
                      } else if (state is SearchArtistQueryErrorState) {
                        return Center(child: Text("there is the error"));
                      }
                      return Center(
                          child: Text('Please enter a search query...'));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
