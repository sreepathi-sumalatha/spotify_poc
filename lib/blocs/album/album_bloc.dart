import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';
import 'package:spotify_app_poc/repository/spotify_repository.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final ApiService apiService;
  AlbumBloc(this.apiService) : super(AlbumInitial()) {
    on<AlbumFetchEvent>(albumFetchEvent);
    on<LoadMoreAlbumEvent>(loadMoreAlbumEvent);
  }

  List<Item> loadAlbums = [];
  FutureOr<void> albumFetchEvent(
      AlbumFetchEvent event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoadingState());
      final albumDataa = await apiService.albumList();
      loadAlbums.addAll(albumDataa);
      emit(AlbumSuccessesState(albumDataList: loadAlbums));
    } catch (error) {
      emit(AlbumErrorState(error: error.toString()));
    }
  }

  FutureOr<void> loadMoreAlbumEvent(
      LoadMoreAlbumEvent event, Emitter<AlbumState> emit) async {
    try {
      var oldData = (state as AlbumSuccessesState).albumDataList;
      final newData = await apiService.albumList();
      oldData!.addAll(newData);

      emit(AlbumSuccessesState(albumDataList: oldData));
    } catch (error) {
      emit(AlbumErrorState(error: error.toString()));
    }
  }
}
