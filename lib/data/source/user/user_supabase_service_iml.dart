import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/data/models/user/user_model.dart';
import 'package:spotify_me/data/source/user/user_service.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSupabaseServiceIml extends UserService {
  @override
  Future<Either<dynamic, dynamic>> UpdateUser(UserEntity user) async {
    try {
      final userId = sl<SupabaseClient>().auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }
      await sl<SupabaseClient>()
          .from('users')
          .update(user.toUserModel().toJson())
          .eq('id', userId);
      return const Right('Update user successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> getUser() async {
    // TODO: implement getUser
    try {
      final userId = sl<SupabaseClient>().auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }
      var result = await sl<SupabaseClient>()
          .from('users')
          .select()
          .eq('id', userId);
      if (result.isEmpty) {
        return Left('User not exists');
      } else {
        return Right(UserModel.fromJson(result[0]).toEntity());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
