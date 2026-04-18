import 'package:dartz/dartz.dart';

abstract class FavouriteRepository {
  Future<Either> getFavouriteSongs();
  Future<Either> addFavouriteSong(String songId);
  Future<Either> removeFavouriteSong(String songId);
  Future<Either> isSongInFavourite(String songId);
}
