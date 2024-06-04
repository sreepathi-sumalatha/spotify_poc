part of 'search_artists_bloc.dart';

abstract class SearchArtistsEvent {}

class SearchArtistsByQueryEvent extends SearchArtistsEvent {
  final String query;

  SearchArtistsByQueryEvent(this.query);
}

class LoadMoreArtistsEvent extends SearchArtistsEvent {}
