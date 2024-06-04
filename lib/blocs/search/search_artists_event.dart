part of 'search_artists_bloc.dart';

@immutable
abstract class SearchArtistsEvent {}

class SearchArtistsByQueryEvent extends SearchArtistsEvent {
  final String query;

  SearchArtistsByQueryEvent(this.query);
}

class LoadMoreArtistsEvent extends SearchArtistsEvent {}
