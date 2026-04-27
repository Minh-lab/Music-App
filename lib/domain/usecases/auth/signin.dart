import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';
import 'package:spotify_me/domain/repositories/auth/auth_repository.dart';
import 'package:spotify_me/service_locator.dart';

class SigninUsecase extends UseCase<Either, SigninRequest> {
  @override
  Future<Either<dynamic, dynamic>> call({SigninRequest? params}) async {
    // TODO: implement call
    return sl<AuthRepository>().signin(params!);
  }
}
