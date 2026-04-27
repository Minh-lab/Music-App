import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> searchSong(String query);
  Future<Either> searchSongFavourite(String query);


}