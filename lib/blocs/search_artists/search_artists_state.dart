import 'package:spotify_app_poc/models/search_artists_model/artist_model.dart';

abstract class SearchArtistsState {}

class SearchArtistsInitial extends SearchArtistsState {}

class SearchArtistQuerySuccessState extends SearchArtistsState {
  final List<ArtistModel> artists;
  final bool hasReachedEnd;

  SearchArtistQuerySuccessState(this.artists, {this.hasReachedEnd = false});
}

class SearchArtistQueryLoadingState extends SearchArtistsState {}

class SearchArtistQueryErrorState extends SearchArtistsState {
  final String? error;
  SearchArtistQueryErrorState({this.error});
}
