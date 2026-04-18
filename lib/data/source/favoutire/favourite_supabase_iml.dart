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
      // Supabase tự động filter theo Row Level Security (RLS) cho auth.uid()
      // Nên chỉ cần query bảng favourites.
      // Dùng cú pháp JOIN 'songs(*)' để lấy luôn thông tin bài hát dựa trên foreign key song_id.
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
      // Dùng match đảm bảo xoá bằng chính xác tổ hợp song_id và user_id
      await sl<SupabaseClient>()
          .from('favourites')
          .delete()
          .match({'song_id': songId, 'user_id': userId});
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

  
}
