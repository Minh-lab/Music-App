import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/song/search_song.dart';
import 'package:spotify_me/presentation/explore/bloc/search_song_state.dart';
import 'package:spotify_me/service_locator.dart';

class SearchSongCubit extends Cubit<SearchSongState> {
  SearchSongCubit() : super(SearchSongInitial());
  Future<void> searchSong(String query) async {
    try {
      if (query.trim().isEmpty) {
        emit(SearchSongInitial());
        return;
      }
      emit(SearchSongLoading());
      var result = await sl<SearchSongUsecase>().call(params: query);
      result.fold(
        (l) {
          emit(SearchSongFailure(errorMessage: l.toString()));
        },
        (r) {
          emit(SearchSongLoaded(songs: r));
        },
      );
    } catch (e) {
      print(e.toString());
      emit(SearchSongFailure(errorMessage: e.toString()));
    }
  }
}
