import 'package:dartz/dartz.dart';

abstract class ArtistsRepository {
  Future<Either> getArtists();
  Future<Either> getArtistsById(String id);
}
