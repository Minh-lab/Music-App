import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/repositories/song/song_repository.dart';
import 'package:spotify_me/presentation/home/bloc/new_songs_cubit/news_song_state.dart';
import 'package:spotify_me/service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongState> {
  NewsSongsCubit() : super(NewsSongLoading());
  Future<void> getNewsSongs() async {
    var result = await sl<SongRepository>().getNewsSongs();
    result.fold(
      (l) {
        if (!isClosed) emit(NewsSongLoadFailure());
      },
      (data) {
        if (!isClosed) emit(NewsSongLoaded(songs: data));
      },
    );
  }
}
