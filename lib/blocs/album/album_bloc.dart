import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:spotify_app_poc/repository/services.dart';
import 'package:spotify_app_poc/models/album/album_model.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc() : super(AlbumInitial()) {
    on<AlbumFetchEvent>(albumFetchEvent);
    on<LoadMoreAlbumEvent>(loadMoreAlbumEvent);
  }

  List<Item> loadAlbums = [];
  var apiService = ApiService(Client());
  FutureOr<void> albumFetchEvent(
      AlbumFetchEvent event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoadingState());
      final albumDataa = await apiService.albumList();
      loadAlbums.addAll(albumDataa);
      // print(loadAlbums.map((e) => e.name));
      emit(AlbumSuccessesState(albumDataList: loadAlbums));
    } catch (error) {
      emit(AlbumErrorState(error: error.toString()));
    }
  }

  FutureOr<void> loadMoreAlbumEvent(
      LoadMoreAlbumEvent event, Emitter<AlbumState> emit) async {
    var oldData = (state as AlbumSuccessesState).albumDataList;
    final newData = await apiService.albumList();
    oldData!.addAll(newData);
    //other way to add the listviews using spread operator
    //  var otherList = [...oldData, ...newData];
    emit(AlbumSuccessesState(albumDataList: oldData));
  }
}
