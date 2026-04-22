import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/widgets/PlaySongPages/pages/play_song.dart';

Widget PlaySongButton(
  BuildContext context,
  SongEntity song,
  List<SongEntity> songs,
) {
  return IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaySong(songEntity: song, playlist: songs),
        ),
      );
    },
    icon: Icon(
      Icons.play_circle_filled,
      color: context.isDarkMode ? Color(0xFF959595) : Color(0xFF555555),
      size: 18,
    ),
  );
}
