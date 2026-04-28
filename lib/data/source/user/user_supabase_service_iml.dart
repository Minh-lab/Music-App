import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/data/models/user/user_model.dart';
import 'package:spotify_me/data/models/user/user_update_request.dart';
import 'package:spotify_me/data/source/user/user_service.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSupabaseServiceIml extends UserService {
  @override
  Future<Either<dynamic, dynamic>> UpdateUser(UserUpdateRequest user) async {
    try {
      final userId = sl<SupabaseClient>().auth.currentUser?.id;
      if (userId == null) {
        return const Left('User not login');
      }

      // 1. Kiểm tra email trùng (Business Validation)
      if (user.email != null && user.email!.trim().isNotEmpty) {
        final checkEmail = await sl<SupabaseClient>()
            .from('users')
            .select('id')
            .eq('email', user.email!.trim())
            .neq('id', userId) // Bỏ qua email của chính mình
            .maybeSingle();

        if (checkEmail != null) {
          return const Left('Email already exists in the system');
        }
      }

      // 2. Thực hiện cập nhật
      await sl<SupabaseClient>()
          .from('users')
          .update(user.toJson())
          .eq('id', userId);
      return const Right('Update user successfully');
    } on PostgrestException catch (e) {
      // Supabase quăng lỗi nghiệp vụ (ví dụ: duplicate email, unique constraint)
      return Left(e.message);
    } on AuthException catch (e) {
      return Left(e.message);
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
