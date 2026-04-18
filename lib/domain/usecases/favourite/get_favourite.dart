import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/data/repositories/favourite/favourite_repository_iml.dart';
import 'package:spotify_me/domain/repositories/favourite/favourite_repository.dart';
import 'package:spotify_me/service_locator.dart';

class GetFavouriteUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) async {
    // TODO: implement call
    return await sl<FavouriteRepository>().getFavouriteSongs();
  }
}
