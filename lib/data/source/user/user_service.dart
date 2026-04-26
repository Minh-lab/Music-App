import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/user/user_model.dart';
import 'package:spotify_me/data/models/user/user_update_request.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';

abstract class UserService {
  Future<Either> getUser();
  Future<Either> UpdateUser(UserUpdateRequest user);
}
