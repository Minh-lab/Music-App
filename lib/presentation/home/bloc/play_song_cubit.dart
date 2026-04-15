import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_me/presentation/home/bloc/play_song_state.dart';

class PlaySongCubit extends Cubit<PlaySongState> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;

  AudioPlayer get audioPlayer => _player;
  String? get currentUrl => _currentUrl;
  PlaySongCubit() : super(PlaySongInitial()) {
    // Chỉ lắng nghe stream 1 lần duy nhất ở constructor
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _player.stop();
        _player.seek(Duration.zero);
        emit(PlaySongPause());
      }
    });
  }

  Future<void> playOrPause(String audioUrl) async {
    try {
      if (_player.playing && _currentUrl == audioUrl) {
        await _player.pause();
        emit(PlaySongPause());
        return;
      }
      if (_currentUrl != audioUrl) {
        _currentUrl = audioUrl;
        await _player.setUrl(audioUrl);
      }
      emit(PlaySongStart());
      await _player.play();
    } catch (e) {
      print(e);
      print('pause song');
      await _player.pause();

    }
  }

  @override
  Future<void> close() {
    _player.dispose(); // Bắt buộc phải có để tránh tốn RAM
    return super.close();
  }
}
