import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/domain/repositories/auth/auth.dart';
import 'package:spotify_me/service_locator.dart';

class SignupUsecase extends UseCase<Either,CreateUserRequest> {
  @override
  Future<Either<dynamic, dynamic>> call({CreateUserRequest? params}) {
    // TODO: implement call
    return sl<AuthRepository>().signup(params!);
  }

}