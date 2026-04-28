import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/data/source/favoutire/favourite_service.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteSupabaseIml extends FavouriteService {
  @override
  Future<Either> getFavouriteSongs() async {
    try {

      var data = await sl<SupabaseClient>()
          .from('favourites')
          .select('song_id, songs(*)');

      List<SongEntity> favouriteList = [];

      for (var element in data) {
        // Supabase trả về key là tên bảng (songs) cho dữ liệu JOIN
        if (element['songs'] != null) {
          final songModel = SongModel.fromJson(element['songs']);
          favouriteList.add(songModel.toEntity());
        }
      }

      return Right(favouriteList);
    } catch (e) {
      print('Error getting favourite songs: $e');
      return const Left('Lỗi khi tải danh sách bài hát yêu thích');
    }
  }

  @override
  Future<Either<dynamic, dynamic>> addFavouriteSong(String songId) async {
    // TODO: implement addFavouriteSong
    try {
      final supabase = sl<SupabaseClient>();
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }
      await supabase.from('favourites').insert({
        'user_id': userId,
        'song_id': songId,
      });
      return const Right('Add song to favourite successfully');
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> removeFavouriteSong(String songId) async {
    try {
      final userId = sl<SupabaseClient>().auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }

      await sl<SupabaseClient>().from('favourites').delete().match({
        'song_id': songId,
        'user_id': userId,
      });
      return const Right('Remove song from favourite successfully');
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> isSongInFavourite(String songId) async {
    // TODO: implement isSongInFavourite
    try {
      final userId = sl<SupabaseClient>().auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }
      var result = await sl<SupabaseClient>()
          .from('favourites')
          .select()
          .eq('song_id', songId)
          .eq('user_id', userId);
      return Right(result.isNotEmpty);
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> searchSongInFavourite(String query) async {
    // TODO: implement searchSongInFavourite
    try {
      final userId = sl<SupabaseClient>().auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }
      var result = await sl<SupabaseClient>()
          .from('favourites')
          .select('*, songs!inner(*)')
          .eq('user_id', userId)
          // .ilike('songs.title', '%$query%');
          .or(
            'title.ilike.%$query%,artist.ilike.%$query%',
            referencedTable: 'songs',
          );

      // print(
      //   result.map((e) => SongModel.fromJson(e['songs']).toEntity() ).toList(),
      // );
      return Right(result.map((e) => SongModel.fromJson(e['songs']).toEntity()).toList());
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }
}
