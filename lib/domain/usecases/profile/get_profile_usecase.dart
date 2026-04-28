import 'package:dartz/dartz.dart';
import 'package:spotify_me/core/usecases/usecase.dart';
import 'package:spotify_me/domain/repositories/user_repository/user_repository.dart';
import 'package:spotify_me/service_locator.dart';

class GetProfileUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) async {
    // TODO: implement call
    return await sl<UserRepository>().getUser();
  }
}
