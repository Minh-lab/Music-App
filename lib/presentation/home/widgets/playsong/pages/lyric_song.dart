import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';

import 'package:spotify_me/domain/entities/song/song.dart';

class LyricSong extends StatelessWidget {
  final SongEntity? songEntity;
  const LyricSong({this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: Text('Lyrics'), enableChangeTheme: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: Text(
            songEntity?.lyric != null && songEntity!.lyric!.isNotEmpty
                ? songEntity!.lyric!
                : "Lyrics not available for this song.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
