import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:spotify_app_poc/repository/services.dart';
import 'package:spotify_app_poc/utils/constants.dart';
import 'package:spotify_app_poc/models/album_model.dart';
import 'package:http/http.dart' as http;

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc() : super(AlbumInitial()) {
    on<AlbumFetchEvent>(albumFetchEvent);
    on<LoadMoreAlbumEvent>(loadMoreAlbumEvent);
  }

  List<Item> loadAlbums = [];

  FutureOr<void> albumFetchEvent(
      AlbumFetchEvent event, Emitter<AlbumState> emit) async {
    try {
      // print('Fetching albums');
      emit(AlbumLoadingState());
      final albumDataa = await ApiService.albumList();
      loadAlbums.addAll(albumDataa);
      // print(loadAlbums.map((e) => e.name));
      emit(AlbumSuccessesState(albumDataList: loadAlbums));
    } catch (error) {
      emit(AlbumErrorState(error: error.toString()));
    }
  }

  FutureOr<void> loadMoreAlbumEvent(
      LoadMoreAlbumEvent event, Emitter<AlbumState> emit) async {
    // print("this is the loadmoreevent");
    var oldData = (state as AlbumSuccessesState).albumDataList;
    final newData = await ApiService.albumList();
    oldData!.addAll(newData);
    //other way to add the listviews using spread operator
    //  var otherList = [...oldData, ...newData];
    emit(AlbumSuccessesState(albumDataList: oldData));
  }
}
