import 'package:dartz/dartz.dart';

abstract class ArtistsService {
  Future<Either> getArtists();
  Future<Either> getArtistsById(String id);

}