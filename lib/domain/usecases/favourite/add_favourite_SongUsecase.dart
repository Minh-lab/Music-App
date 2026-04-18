import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/data/repositories/favourite/favourite_repository_iml.dart';
import 'package:spotify_me/domain/repositories/favourite/favourite_repository.dart';
import 'package:spotify_me/domain/repositories/song/song_repository.dart';
import 'package:spotify_me/service_locator.dart';

class AddFavouriteSongUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) async {
    return await sl<FavouriteRepository>().addFavouriteSong(params);
  }
}
