import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/auth/logout.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_cubit.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/Bloc/play_song_cubit/play_song_cubit.dart';
import 'package:spotify_me/presentation/profile/bloc/logout/logout_state.dart';
import 'package:spotify_me/service_locator.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());
  Future<void> logout() async {
    emit(LogoutLoading());
    var result = await sl<LogoutUsecase>().call();
    result.fold(
      (l) {
        emit(LogoutFailure());
      },
      (r) async {
        if (r == true) {
          // Xóa dữ liệu cũ của các Singleton để người dùng mới đăng nhập không bị trùng
          sl<FavouriteCubit>().clearData();
          await sl<PlaySongCubit>().stopAndClear();
          
          emit(LogoutSuccess());
        } else {
          emit(LogoutFailure());
        }
      },
    );
  }
}
