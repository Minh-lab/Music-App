import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/bloc/play_song_cubit.dart';
import 'package:spotify_me/presentation/home/bloc/play_song_state.dart';

class PlaySong extends StatelessWidget {
  SongEntity? songEntity;
  PlaySong({this.songEntity, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: Text('Now Playing'), enableChangeTheme: false),
      body: BlocProvider(
        create: (_) => PlaySongCubit(),
        child: BlocBuilder<PlaySongCubit, PlaySongState>(
          builder: (context, songState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    _artistsCard(context, songEntity!),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      // spacing: 40,
                      children: [
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            _titleSong(context, songEntity!.title!),
                            SizedBox(height: 8),
                            _artistSong(context, songEntity!.artist),
                          ],
                        ),
                        _favouriteButton(() {}),
                      ],
                    ),
                    _sliderPlay(context),
                    // more action button
                    SizedBox(height: 20),
                    Row(
                      spacing: 20,
                      mainAxisAlignment: .center,
                      children: [
                        _previousSongButton(context, () {}),
                        _playSongButton(songState, () async {
                          print(songState.toString());
                          context.read<PlaySongCubit>().playOrPause(
                            songEntity!.audioUrl!,
                          );
                        }),
                        _nextSongButton(context, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _artistsCard(BuildContext context, SongEntity song) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: NetworkImage(song.coverUrl!),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _sliderPlay(BuildContext context) {
    final player = context.read<PlaySongCubit>().audioPlayer;

    // Dùng StreamBuilder để slider tự chạy không cần gọi setState
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = player.duration ?? Duration.zero;

        return Column(
          children: [
            Transform.scale(
              scaleX: 1.1,
              child: Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: duration.inSeconds.toDouble() > 0
                    ? duration.inSeconds.toDouble()
                    : 1.0,
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey.withValues(alpha: 0.3),
                onChanged: (value) {
                  player.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position)),
                  Text(_formatDuration(duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Hàm format thời gian mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _titleSong(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: context.isDarkMode ? Color(0xFFDFDFDF) : Colors.black,
        fontSize: 18,
        fontWeight: .bold,
      ),
    );
  }

  Widget _artistSong(BuildContext context, String artist) {
    return Text(
      artist,
      style: TextStyle(
        fontSize: 16,
        color: context.isDarkMode ? Color(0xFFBABABA) : Color(0xFF404040),
      ),
    );
  }

  Widget _favouriteButton(VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.favorite_border_rounded),
    );
  }

  Widget _playSongButton(PlaySongState state, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: (state is PlaySongStart)
            ? Icon(Icons.pause_outlined, size: 50, color: Colors.white)
            : Icon(Icons.play_arrow_outlined, size: 50, color: Colors.white),
      ),
    );
  }

  Widget _previousSongButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.skip_previous_outlined,
        size: 40,
        color: context.isDarkMode ? Color(0XFFA7A7A7) : Color(0xFF363636),
      ),
    );
  }

  Widget _nextSongButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.skip_next_outlined,
        size: 40,
        color: context.isDarkMode ? Color(0XFFA7A7A7) : Color(0xFF363636),
      ),
    );
  }
}
