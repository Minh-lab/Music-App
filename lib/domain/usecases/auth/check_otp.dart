import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/domain/repositories/auth/auth_repository.dart';
import 'package:spotify_me/service_locator.dart';

class CheckOtpParams {
  final String email;
  final String otp;

  CheckOtpParams({required this.email, required this.otp});
}

class CheckOtpUsecase extends UseCase<Either, CheckOtpParams> {
  @override
  Future<Either<dynamic, dynamic>> call({CheckOtpParams? params}) async {
    return await sl<AuthRepository>().checkOtpResetPassword(
      params!.email,
      params.otp,
    );
  }
}
