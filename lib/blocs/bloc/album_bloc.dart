import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_app_poc/models/album_model.dart';
import 'package:spotify_app_poc/repository/album_service.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc() : super(AlbumInitial()) {
    on<AlbumFetchEvent>(albumFetchEvent);
    on<LoadMoreAlbumEvent>(loadMoreAlbumEvent);
  }
  List<Album> loadAlbums = [];
  FutureOr<void> albumFetchEvent(
      AlbumFetchEvent event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoadingState());
      final albumDataa = await ApiService.albumList();

      loadAlbums.addAll(albumDataa);
      emit(AlbumSuccessesState(albumDataList: loadAlbums));
    } catch (error) {
      emit(AlbumErrorState(error: error.toString()));
    }
  }

  FutureOr<void> loadMoreAlbumEvent(
      LoadMoreAlbumEvent event, Emitter<AlbumState> emit) {}
}
