import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/source/artists/artists_service.dart';
import 'package:spotify_me/domain/repositories/artists/artists_repository.dart';
import 'package:spotify_me/service_locator.dart';

class ArtistsRepositoryIml extends ArtistsRepository {
  @override
  Future<Either<dynamic, dynamic>> getArtists() async {
    return await sl<ArtistsService>().getArtists();
  }

  @override
  Future<Either<dynamic, dynamic>> getArtistsById(String id) async {
    return await sl<ArtistsService>().getArtistsById(id);
  }
}
