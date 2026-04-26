import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/user/user_model.dart';
import 'package:spotify_me/data/models/user/user_update_request.dart';
import 'package:spotify_me/data/source/user/user_service.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/domain/repositories/user_repository/user_repository.dart';
import 'package:spotify_me/service_locator.dart';

class UserRepositoryIml extends UserRepository {
  @override
  Future<Either<dynamic, dynamic>> updateUser(UserUpdateRequest user) async {
    return await sl<UserService>().UpdateUser(user);
  }

  @override
  Future<Either<dynamic, dynamic>> getUser() async {
    // TODO: implement getUser
    return await sl<UserService>().getUser();
  }
}
