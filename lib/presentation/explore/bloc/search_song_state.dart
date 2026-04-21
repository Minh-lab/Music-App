import 'package:spotify_me/domain/entities/song/song.dart';

abstract class SearchSongState {}

class SearchSongInitial extends SearchSongState {}

class SearchSongLoading extends SearchSongState {}

class SearchSongLoaded extends SearchSongState {
  final List<SongEntity> songs;

  SearchSongLoaded({required this.songs});
}

class SearchSongFailure extends SearchSongState {
  final String errorMessage;

  SearchSongFailure({required this.errorMessage});
}
