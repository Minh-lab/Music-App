import 'package:dartz/dartz.dart';
import 'package:spotify_me/data/source/auth/auth_service.dart';
import 'package:spotify_me/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';

class AuthSupabaseServiceImpl extends AuthService {
  @override
  Future<Either> signin(SigninRequest signinRequest) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: signinRequest.userOrEmail,
        password: signinRequest.password,
      );

      return const Right('Sign in Successful');
    } on AuthException catch (e) {
      String message = '';
      if (e.message.contains('Invalid login credentials')) {
        message = 'Wrong email or password';
      } else {
        message = e.message;
      }
      return Left(message);
    } catch (e) {
      print(e);
      return const Left('An error occurred');
    }
  }

  @override
  Future<Either> signup(CreateUserRequest createUserReq) async {
    try {
      var data = await Supabase.instance.client.auth.signUp(
        email: createUserReq.email,
        password: createUserReq.password,
        // data: {'full_name': createUserReq.fullName}, // Uncomment if you have fullName)
      );

      await Supabase.instance.client.from('users').insert({
        'id': data.user?.id, // Must match the auth.uid()!
        'name': createUserReq.fullName,
        'email': data.user?.email,
      });

      return const Right('Signup successful');
    } on AuthException catch (e) {
      String message = e.message;
      return Left(message);
    } catch (e) {
      print('LỖI SIGNUP: $e ');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> logout() async {
    // TODO: implement logout
    try {
      await sl<SupabaseClient>().auth.signOut();
      return const Right(true);
    } catch (e) {
      print(e.toString());
      return const Left(false);
    }
  }

  @override
  Future<Either<dynamic, dynamic>> sendOtpResetPassword(String email) async {
    // TODO: implement sendOtpResetPassword
    try {
      await sl<SupabaseClient>().auth.resetPasswordForEmail(email);
      print('Sent otp to email $email');
      return Right('Sent to email successfully');
    } catch (e) {
      print('error $e');
      return Left('Error send to email, try again');
    }
  }

  @override
  Future<Either<dynamic, dynamic>> changePassword({
    required String newPassword,
  }) async {
    // TODO: implement verifyOtpAndChangePassword
    try {
      await sl<SupabaseClient>().auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return Right('Change password succesfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> checkOtpResetPassword(
    String email,
    String otpCode,
  ) async {
    // TODO: implement checkOtpResetPassword
    try {
  
      await sl<SupabaseClient>().auth.verifyOTP(
        email: email,
        token: otpCode,
        type: OtpType.recovery,
      );
      return Right('verify OTP success');

      print('Mã OTP chính xác!');
    } on AuthException catch (e) {
      print('Mã sai hoặc hết hạn: ${e.message}');
      return Left('OTP is not correct');
    } catch (e) {
      print('Lỗi hệ thống: $e');
      return Left('Error System');
    }
  }
}
