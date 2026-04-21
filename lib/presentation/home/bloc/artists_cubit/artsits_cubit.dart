import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/artists/get_artists.dart';
import 'package:spotify_me/presentation/home/bloc/artists_cubit/artists_state.dart';
import 'package:spotify_me/service_locator.dart';

class ArtsitsCubit extends Cubit<ArtistsState> {
  ArtsitsCubit() : super(ArtistsLoading());
  Future<void> getArtists() async {
    var result = await sl<GetArtistsUsecase>().call();
    result.fold(
      (l) {
        if (!isClosed) emit(ArtistsLoadFailure(errorMessage: l.toString()));
      },
      (r) {
        if (!isClosed) emit(ArtistsLoaded(listArtists: r));
      },
    );
  }
}
