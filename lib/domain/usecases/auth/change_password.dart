import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/domain/repositories/auth/auth_repository.dart';
import 'package:spotify_me/service_locator.dart';

class ChangePasswordUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().changePassword(newPassword: params);
  }
}
