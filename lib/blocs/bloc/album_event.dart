part of 'album_bloc.dart';

abstract class AlbumEvent {}

final class AlbumFetchEvent extends AlbumEvent {}

final class LoadMoreAlbumEvent extends AlbumEvent {}
