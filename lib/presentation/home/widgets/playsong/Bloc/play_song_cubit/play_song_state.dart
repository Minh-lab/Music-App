abstract class PlaySongState {}

class PlaySongInitial extends PlaySongState {}

class PlaySongStart extends PlaySongState {}

class PlaySongPause extends PlaySongState {}

class PlaySongError extends PlaySongState {
  String? errorMessage;
  PlaySongError(this.errorMessage);
}

class StartPlayLoop extends PlaySongState {}
class StopPlayLoop extends PlaySongState {}
