import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/domain/repositories/artists/artists_repository.dart';
import 'package:spotify_me/service_locator.dart';

class GetArtistsUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) {
    // TODO: implement call
    return sl<ArtistsRepository>().getArtists();
  }
}
