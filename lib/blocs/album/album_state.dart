part of 'album_bloc.dart';

abstract class AlbumState {}

final class AlbumInitial extends AlbumState {}

final class AlbumLoadingState extends AlbumState {}

final class AlbumSuccessesState extends AlbumState {
  List<Item>? albumDataList;
  AlbumSuccessesState({this.albumDataList});
}

final class AlbumErrorState extends AlbumState {
  final String? error;
  AlbumErrorState({this.error});
}

final class AlbumLoadingMoreState extends AlbumState {}
