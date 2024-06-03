part of 'search_artists_bloc.dart';

abstract class SearchArtistsState {}

final class SearchArtistsInitial extends SearchArtistsState {}

class SearchArtistQuerySuccessState extends SearchArtistsState {
  List<ArtistModel> artists;

  SearchArtistQuerySuccessState(this.artists);
}

class SearchArtistQueryLoadingState extends SearchArtistsState {}

class SearchArtistQueryErrorState extends SearchArtistsState {}
