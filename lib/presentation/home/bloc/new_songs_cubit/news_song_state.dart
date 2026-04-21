import 'package:spotify_me/domain/entities/song/song.dart';

abstract class NewsSongState {}

class NewsSongLoading extends NewsSongState {}
class NewsSongLoadFailure extends NewsSongState {}

class NewsSongLoaded extends NewsSongState {
  final List<SongEntity> songs;

  NewsSongLoaded({required this.songs});
}
