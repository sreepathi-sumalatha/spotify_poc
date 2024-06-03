import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_app_poc/models/album_model.dart';
import 'package:spotify_app_poc/utils/constants.dart';
import 'package:spotify_app_poc/models/artist_model.dart';
import 'package:spotify_app_poc/repository/album_service.dart';

part 'search_artists_event.dart';
part 'search_artists_state.dart';

class SearchArtistsBloc extends Bloc<SearchArtistsEvent, SearchArtistsState> {
  SearchArtistsBloc() : super(SearchArtistsInitial()) {
    on<SearchArtistsByQueryEvent>(_searchArtistsByQuery);
    on<LoadMoreArtistsEvent>(loadMoreArtistsEvent);
  }
  FutureOr<void> _searchArtistsByQuery(
      SearchArtistsByQueryEvent event, Emitter<SearchArtistsState> emit) async {
    emit(SearchArtistQueryLoadingState());
    try {
      final artistData = await ApiService.searchArtists(
        query: event.query,
        token: Constants.token,
      );
      emit(SearchArtistQuerySuccessState(artistData));
    } catch (e) {
      print(e.toString());
      log(e.toString());
      emit(SearchArtistQueryErrorState());
    }
  }

  FutureOr<void> loadMoreArtistsEvent(
      LoadMoreArtistsEvent event, Emitter<SearchArtistsState> emit) async {
    var oldSearchData = (state as SearchArtistQuerySuccessState).artists;
    final newArtistData = await ApiService.searchArtists(
        query: "artists", token: Constants.token);

    oldSearchData.addAll(newArtistData);

    emit(SearchArtistQuerySuccessState(oldSearchData));
  }
}
