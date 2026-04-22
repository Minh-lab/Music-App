import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/favourite/add_favourite_SongUsecase.dart';
import 'package:spotify_me/domain/usecases/favourite/get_favourite.dart';
import 'package:spotify_me/domain/usecases/favourite/is_song_in_favourite.dart';
import 'package:spotify_me/domain/usecases/favourite/remove_song_favourite.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_state.dart';
import 'package:spotify_me/service_locator.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteLoading());
  Future<void> getFavourite() async {
    emit(FavouriteLoading());

    var result = await sl<GetFavouriteUsecase>().call();
    result.fold(
      (l) {
        emit(FavouriteFailure());
      },
      (data) {
        emit(FavouriteLoaded(list: data));
      },
    );
  }

  Future<void> addFavourite(String songId) async {
    var result = await sl<AddFavouriteSongUsecase>().call(params: songId);
    result.fold(
      (l) {
        emit(FavouriteAddFailure(errorMessage: l));
      },
      (r) {
        emit(FavouriteAddSuccess());
        getFavourite();
      },
    );
  }

  Future<void> removeFavourite(String songId) async {
    var result = await sl<RemoveSongFavouriteUsecase>().call(params: songId);
    result.fold(
      (l) {
        print('error');
        if (!isClosed) emit(FavouriteRemoveFailure(errorMessage: l));
      },
      (r) {
        print('delete song from favourite success');
        if (!isClosed) emit(FavouriteRemoveSuccess());
        getFavourite();
      },
    );
  }
}
