import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/domain/repositories/auth/auth.dart';
import 'package:spotify_me/service_locator.dart';

class LogoutUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) {
    // TODO: implement call
    return sl<AuthRepository>().logout();
  }
}
