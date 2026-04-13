import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';
import 'package:spotify_me/data/source/auth/auth_service.dart';
import 'package:spotify_me/domain/repositories/auth/auth.dart';
import 'package:spotify_me/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<dynamic, dynamic>> signin(SigninRequest signinRequest) async {
    // TODO: implement signin
    return await sl<AuthService>().signin(signinRequest);
  }

  @override
  Future<Either> signup(CreateUserRequest createUserReq) async {
    // TODO: implement signup
    return await sl<AuthService>().signup(createUserReq);
  }
}

