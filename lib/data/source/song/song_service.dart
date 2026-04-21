import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/song/song_model.dart';

abstract class SongService {
  Future<Either> getNewsSongs();
  Future<Either> searchSong(String query);
  Future<void> syncToDatabase(List<SongModel> songs);
}