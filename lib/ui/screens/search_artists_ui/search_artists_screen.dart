import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_bloc.dart';
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';
import 'package:spotify_app_poc/ui/screens/album/reusable_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchArtistsBloc artistBloc;
  final _controller = ScrollController();
  late final ApiService apiService;
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Client());
    artistBloc = SearchArtistsBloc(apiService);
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          artistBloc.add(LoadMoreArtistsEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    artistBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => artistBloc,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.deepPurple),
            title: const Center(
              child: Text(
                'Search ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    currentQuery = query;
                    artistBloc.add(SearchArtistsByQueryEvent(query));
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
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<SearchArtistsBloc, SearchArtistsState>(
                    builder: (context, state) {
                      if (state is SearchArtistQueryLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SearchArtistQuerySuccessState) {
                        return ListView.builder(
                          controller: _controller,
                          itemCount: state.hasReachedEnd
                              ? state.artists.length + 1
                              : state.artists.length + 1,
                          itemBuilder: (context, index) {
                            if (index == state.artists.length) {
                              if (state.hasReachedEnd) {
                                return const Center(
                                  child: Text(
                                    '.....Reached end of the records....',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                            var artist = state.artists[index];
                            return ReusableCard(
                              imageUrl: artist.image.isNotEmpty
                                  ? artist.image
                                  : 'https://homestaymatch.com/images/no-image-available.png',
                              title: artist.name,
                              subtitle: 'Popularity: ${artist.popularity}',
                              onTap: () {
                                // Handle tap
                              },
                              onIconPressed: () {
                                print('Music button pressed');
                              },
                            );
                          },
                        );
                      } else if (state is SearchArtistQueryErrorState) {
                        return const Center(child: Text('There is an error'));
                      }
                      return const Center(
                        child: Text(
                          'Please enter a search query...',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      );
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
