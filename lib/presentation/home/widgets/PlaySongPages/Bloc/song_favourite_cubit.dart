import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/favourite/is_song_in_favourite.dart';
import 'package:spotify_me/presentation/home/widgets/PlaySongPages/Bloc/song_favourite_state.dart';
import 'package:spotify_me/service_locator.dart';

class SongFavouriteCubit extends Cubit<SongFavouriteState> {
  SongFavouriteCubit() : super(SongNotInFavourite());
  Future<void> IsSongInFavourite(String songId) async {
    var result = await sl<IsSongInFavouriteUsecase>().call(params: songId);


    if (isClosed) return;

    result.fold((l) => emit(SongNotInFavourite()), (r) {
      if (r == true)
        emit(SongInFavourite());
      else
        emit(SongNotInFavourite());
    });
  }

  void toggleFavourite() {
    if (isClosed) return;
    if (state is SongInFavourite) {
      emit(SongNotInFavourite());
    } else {
      emit(SongInFavourite());
    }
  }
}
