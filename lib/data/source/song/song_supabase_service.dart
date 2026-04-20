import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/data/source/song/song_service.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SongSupabaseService extends SongService {
  @override
  Future<Either<dynamic, dynamic>> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await sl<SupabaseClient>().from('songs').select();
      songs = data.map((e) => SongModel.fromJson(e).toEntity()).toList();
      songs.forEach((e)=>print(e.audioUrl));
      return Right(songs);
    } catch (e) {
      print(e);
      return Left('Error while installing songs');
    }
  }
  
  @override
  Future<Either<dynamic, dynamic>> searchSong(String query) {
    // TODO: implement searchSong
    throw UnimplementedError();
  }
  
  @override
  Future<void> syncToDatabase(List<SongModel> songs) {
    // TODO: implement syncToDatabase
    throw UnimplementedError();
  }
}
