import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/favourite/search_songs_in_favourite.dart';
import 'package:spotify_me/presentation/favourite/bloc/search_favourite/search_favourite_state.dart';
import 'package:spotify_me/service_locator.dart';

class SearchFavouriteCubit extends Cubit<SearchFavouriteState> {
  SearchFavouriteCubit() : super(SearchFavouriteInitial());
  Future<void> searchSongInFavourite(String query) async {
    try {
      if(query.trim().isEmpty){
        emit(SearchFavouriteInitial());
        return;
      }
      emit(SearchFavouriteLoading());
      var result = await sl<SearchSongsInFavouriteUsecase>().call(
        params: query,
      );
      result.fold(
        (l) {
          print('error search song in favourite');
          emit(SearchFavouriteFailure(errorMessage: l.toString()));
        },
        (r) {
          print(r);
          emit(SearchFavouriteSuccess(listSongs: r));
        },
      );
    } catch (e) {
                emit(SearchFavouriteFailure(errorMessage: e.toString()));

    }
  }
}
