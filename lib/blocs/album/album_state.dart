part of 'album_bloc.dart';

abstract class AlbumState {}

final class AlbumInitial extends AlbumState {}

final class AlbumLoadingState extends AlbumState {}

final class AlbumSuccessesState extends AlbumState {
  final List<Item>? albumDataList;
  final bool hasReachedEnd;
  AlbumSuccessesState({this.albumDataList, this.hasReachedEnd = false});
}

final class AlbumErrorState extends AlbumState {
  final String? error;
  AlbumErrorState({this.error});
}

final class AlbumLoadingMoreState extends AlbumState {}
