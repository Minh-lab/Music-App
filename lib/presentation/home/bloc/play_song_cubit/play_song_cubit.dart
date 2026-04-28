import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/bloc/play_song_cubit/play_song_state.dart';

class PlaySongCubit extends Cubit<PlaySongState> {
  List<SongEntity> _currentPlaylist = [];
  int _currentIndex = -1;
  bool _loopSong = false;
  StreamSubscription? _loopSub;

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get audioPlayer => _player;
  SongEntity? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _currentPlaylist.length)
      ? _currentPlaylist[_currentIndex]
      : null;

  PlaySongCubit() : super(PlaySongInitial()) {

  }


  void playList(List<SongEntity> playlist, int index) {
    _currentPlaylist = playlist;
    _currentIndex = index;
  }

  
  Future<void> _playCurrentSong() async {
    if (currentSong == null) return;

    try {
      await _player.setUrl(currentSong!.audioUrl!);
      emit(PlaySongStart());
      await _player.play();
    } catch (e) {
      print('Lỗi phát nhạc: $e');
      emit(PlaySongPause());
    }
  }

 
  Future<void> playOrPause() async {
    try {
      if (_player.playing) {
        await _player.pause();
        emit(PlaySongPause());
      } else {
   
        if (_player.duration != null) {
          emit(PlaySongStart());
          await _player.play();
        } else {
          await _playCurrentSong();
        }
      }
    } catch (e) {
      print(e);
      await _player.pause();
      emit(PlaySongPause());
    }
  }

  Future<void> playLoop() async {
    _loopSong = !_loopSong;

    _loopSub?.cancel();

    if (_loopSong) {
      _loopSub = _player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          _playCurrentSong();
        }
      });
    }

    emit(_loopSong ? StartPlayLoop() : StopPlayLoop());
  }

  
  Future<void> nextSong() async {
    if (_currentPlaylist.isEmpty || _currentIndex == -1) return;

    if (_currentIndex < _currentPlaylist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    await _playCurrentSong();
  }

  
  Future<void> previousSong() async {
    if (_currentPlaylist.isEmpty || _currentIndex == -1) return;

   
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }

    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _currentPlaylist.length - 1;
    }
    await _playCurrentSong();
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
