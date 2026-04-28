import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/pages/lyric_song.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/pages/play_song.dart';

class PlaySongController extends StatefulWidget {
  final List<SongEntity> playlist;
  final SongEntity? songEntity;
  const PlaySongController({required this.playlist, this.songEntity, super.key});
  @override
  State<StatefulWidget> createState() {
    return PlaySongControllerState();
  }
}

class PlaySongControllerState extends State<PlaySongController> {
  final PageController _pageController = PageController(initialPage: 0);
  @override
  void dispose() {
    _pageController.dispose(); // Bắt buộc giải phóng RAM
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (int index) {
        print('Trang $index');
      },
      children: [
        PlaySong(playlist: widget.playlist, songEntity: widget.songEntity),
        LyricSong(songEntity: widget.songEntity),
      ],
    );
  }
}
