import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/source/favoutire/favourite_service.dart';
import 'package:spotify_me/domain/repositories/favourite/favourite_repository.dart';
import 'package:spotify_me/service_locator.dart';

class FavouriteRepositoryIml extends FavouriteRepository {
  @override
  Future<Either<dynamic, dynamic>> addFavouriteSong(String songId) async {
    // TODO: implement addFavouriteSong
    return await sl<FavouriteService>().addFavouriteSong(songId);
  }

  @override
  Future<Either<dynamic, dynamic>> getFavouriteSongs() async {
    // TODO: implement getFavouriteSongs
    return await sl<FavouriteService>().getFavouriteSongs();
  }

  @override
  Future<Either<dynamic, dynamic>> removeFavouriteSong(String songId) async {
    // TODO: implement removeFavouriteSong
    return await sl<FavouriteService>().removeFavouriteSong(songId);
  }

  @override
  Future<Either<dynamic, dynamic>> isSongInFavourite(String songId) async {
    // TODO: implement isSongInFavourite
    return await sl<FavouriteService>().isSongInFavourite(songId);
  }
}
