import 'package:dartz/dartz.dart';

abstract class FavouriteService {
  Future<Either> getFavouriteSongs();
  Future<Either> addFavouriteSong(String songId);
  Future<Either> removeFavouriteSong(String songId);    
  Future<Either> isSongInFavourite(String songId);
}