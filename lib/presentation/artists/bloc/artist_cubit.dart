import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/artists/get_artists_by_id.dart';
import 'package:spotify_me/presentation/artists/bloc/artist_state.dart';
import 'package:spotify_me/presentation/home/bloc/artists_cubit/artists_state.dart';
import 'package:spotify_me/service_locator.dart';

class ArtistCubit extends Cubit<ArtistState> {
  ArtistCubit() : super(ArtistGetLoading());
  Future<void> getArtistById(String artistId) async {
    try {
      emit(ArtistGetLoading());
      var result = await sl<GetArtistsByIdUsecase>().call(params: artistId);
      result.fold(
        (l) {
          print(l.toString());
          if (!isClosed) emit(ArtistGetFailure(errorMessage: l.toString()));
        },
        (r) {
          print('get artist by id successfully');
          emit(ArtistGetSuccess(artist: r));
        },
      );
    } catch (e) {
      print(e.toString());
      if (!isClosed) emit(ArtistGetFailure(errorMessage: e.toString()));
    }
  }
}
