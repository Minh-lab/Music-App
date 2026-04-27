import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';

abstract class AuthService {
  Future<Either> signin(SigninRequest signinRequest);
  Future<Either> logout();
  Future<Either> signup(CreateUserRequest createUserReq);
  Future<Either> sendOtpResetPassword(String email);
  Future<Either> changePassword({
  
    required String newPassword,
  });
  Future<Either> checkOtpResetPassword(String email, String otpCode);
}
