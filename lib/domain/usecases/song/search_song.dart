import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/domain/repositories/song/song_repository.dart';
import 'package:spotify_me/service_locator.dart';

class SearchSongUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) {
    return sl<SongRepository>().searchSong(params);
  }
}
