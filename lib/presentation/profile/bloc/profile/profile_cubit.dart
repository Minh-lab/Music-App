import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/data/models/user/user_update_request.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/domain/usecases/profile/get_profile_usecase.dart';
import 'package:spotify_me/domain/usecases/profile/update_profile.dart';
import 'package:spotify_me/presentation/profile/bloc/profile/profile_state.dart';
import 'package:spotify_me/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  Future<void> getProfile() async {
    emit(GetProfileLoading());
    var result = await sl<GetProfileUsecase>().call();
    result.fold(
      (l) {
        emit(GetProfileFailure(errorMessage: l.toString()));
      },
      (r) {
        print('get profile successfully');
        emit(GetProfileSuccess(user: r));
      },
    );
  }

  Future<void> updateProfile(UserUpdateRequest user) async {
    // Chốt chặn cuối cùng ở Cubit trước khi gọi xuống tầng dưới
    if (user.name == null || user.name!.trim().isEmpty) {
      emit(UpdateProfileFailure(errorMessage: 'Full name cannot be empty'));
      return;
    }
    if (user.email == null || user.email!.trim().isEmpty) {
      emit(UpdateProfileFailure(errorMessage: 'Email cannot be empty'));
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(user.email!)) {
      emit(UpdateProfileFailure(errorMessage: 'Please enter a valid email'));
      return;
    }

    var result = await sl<UpdateProfileUsecase>().call(params: user);
    result.fold(
      (l) {
        emit(UpdateProfileFailure(errorMessage: l.toString()));
      },
      (r) {
        emit(UpdateProfileSuccess());

      },
    );
  }
}
