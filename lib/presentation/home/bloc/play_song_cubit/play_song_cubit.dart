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
    // _player.playerStateStream.listen((playerState) {
    //   if (playerState.processingState == ProcessingState.completed) {
    //     // TỰ ĐỘNG CHUYỂN BÀI khi bài hát hiện tại chạy hết
    //     nextSong();
    //   }
    // });
  }

  /// Chỉ đặt playlist và index, KHÔNG tự phát nhạc
  void playList(List<SongEntity> playlist, int index) {
    _currentPlaylist = playlist;
    _currentIndex = index;
  }

  // Tách riêng logic xử lý SetUrl và Play thành 1 hàm nội bộ dùng chung
  /// Load URL mới và phát — chỉ dùng khi đổi bài
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

  // Hàm điều khiển Nút Play/Pause trên giao diện
  Future<void> playOrPause() async {
    try {
      if (_player.playing) {
        await _player.pause();
        emit(PlaySongPause());
      } else {
        // Nếu đã load URL rồi (đang pause) → chỉ resume
        // Nếu chưa load URL (lần đầu bấm Play) → load bài mới
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

  // Logic Next: i + 1
  Future<void> nextSong() async {
    if (_currentPlaylist.isEmpty || _currentIndex == -1) return;

    if (_currentIndex < _currentPlaylist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0; // Vòng lại bài đầu tiên
    }
    await _playCurrentSong();
  }

  // Logic Previous: i - 1
  Future<void> previousSong() async {
    if (_currentPlaylist.isEmpty || _currentIndex == -1) return;

    // Logic giống Spotify: Nếu bài hát đã phát > 3 giây, bấm Previous sẽ tua lại từ đầu bài đó.
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }

    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _currentPlaylist.length - 1; // Nhảy về bài cuối cùng
    }
    await _playCurrentSong();
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
