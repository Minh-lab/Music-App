import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/source/song/song_service.dart';
import 'package:spotify_me/domain/repositories/song/song_repository.dart';
import 'package:spotify_me/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either<dynamic, dynamic>> getNewsSongs() async {
    // TODO: implement getNewsSongs
    return await sl<SongService>().getNewsSongs();
  }
}
