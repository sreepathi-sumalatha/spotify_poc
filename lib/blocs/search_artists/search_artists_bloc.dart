import 'dart:async';
import 'dart:developer';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:spotify_app_poc/blocs/search_artists/search_artists_state.dart';
import 'package:spotify_app_poc/repository/services.dart';
import 'package:spotify_app_poc/utils/constants.dart';

part 'search_artists_event.dart';

class SearchArtistsBloc extends Bloc<SearchArtistsEvent, SearchArtistsState> {
  var apiService = ApiService(Client());
  int offset = 0;
  final int limit = 20;
  bool isLoadingMore = false;
  String currentQuery = '';

  SearchArtistsBloc() : super(SearchArtistsInitial()) {
    on<SearchArtistsByQueryEvent>(_searchArtistsByQuery);
    on<LoadMoreArtistsEvent>(_loadMoreArtists);
  }

  FutureOr<void> _searchArtistsByQuery(
      SearchArtistsByQueryEvent event, Emitter<SearchArtistsState> emit) async {
    emit(SearchArtistQueryLoadingState());
    try {
      currentQuery = event.query;
      offset = 0; // Reset offset for new query
      final artistData = await apiService.searchArtists(
        query: event.query,
        token: Constants.token,
        offset: offset,
        limit: limit,
      );
      offset += limit;
      bool hasReachedEnd = artistData.length < limit;
      emit(SearchArtistQuerySuccessState(artistData,
          hasReachedEnd: hasReachedEnd));
    } catch (e) {
      print(e.toString());
      log(e.toString());
      emit(SearchArtistQueryErrorState());
    }
  }

  FutureOr<void> _loadMoreArtists(
      LoadMoreArtistsEvent event, Emitter<SearchArtistsState> emit) async {
    if (isLoadingMore) return;
    isLoadingMore = true;

    final currentState = state;
    if (currentState is SearchArtistQuerySuccessState &&
        !currentState.hasReachedEnd) {
      try {
        final additionalArtists = await apiService.searchArtists(
          query: currentQuery,
          token: Constants.token,
          offset: offset,
          limit: limit,
        );
        offset += limit;
        bool hasReachedEnd = additionalArtists.length < limit;
        emit(SearchArtistQuerySuccessState(
            currentState.artists + additionalArtists,
            hasReachedEnd: hasReachedEnd));
      } catch (e) {
        print(e.toString());
        log(e.toString());
      }
    }
    isLoadingMore = false;
  }
}
