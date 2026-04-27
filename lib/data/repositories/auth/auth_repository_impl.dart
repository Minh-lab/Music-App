import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';
import 'package:spotify_me/data/source/auth/auth_service.dart';
import 'package:spotify_me/domain/repositories/auth/auth_repository.dart';
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

  @override
  Future<Either<dynamic, dynamic>> logout() async {
    // TODO: implement logout
    return await sl<AuthService>().logout();
  }

  @override
  Future<Either<dynamic, dynamic>> sendOtpResetPassword(String email) async {
    // TODO: implement sendOtpResetPassword
    return await sl<AuthService>().sendOtpResetPassword(email);
  }

  @override
  Future<Either<dynamic, dynamic>> changePassword({
    required String newPassword,
  }) async {
    // TODO: implement changePassword
    return await sl<AuthService>().changePassword(newPassword: newPassword);
  }

  @override
  Future<Either<dynamic, dynamic>> checkOtpResetPassword(
    String email,
    String otpCode,
  ) async {
    // TODO: implement checkOtpResetPassword
    return await sl<AuthService>().checkOtpResetPassword(email, otpCode);
  }
}
