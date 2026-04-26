import 'package:spotify_me/domain/entities/auth/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetProfileLoading extends ProfileState {}

class GetProfileSuccess extends ProfileState {
  UserEntity? user;
  GetProfileSuccess({this.user});
}

class GetProfileFailure extends ProfileState {
  String? errorMessage;
  GetProfileFailure({this.errorMessage});
}

class UpdateProfileFailure extends ProfileState {
  String? errorMessage;
  UpdateProfileFailure({this.errorMessage});
}

class UpdateProfileSuccess extends ProfileState {}
