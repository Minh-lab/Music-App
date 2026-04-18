import 'package:flutter/material.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/widgets/PlaySongPages/pages/play_song.dart';
import 'package:spotify_me/presentation/home/widgets/play_song_button.dart';

class SongListTail extends StatelessWidget {
  BuildContext context;
  SongEntity song;
  Widget? action;
  SongListTail({
    required this.context,
    required this.song,
    this.action,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaySong(songEntity: song,)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20, right: 10),
        child: Row(
          children: [
            // 1. Nút Play
            GestureDetector(onTap: () {}, child: PlaySongButton(context, song)),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.isDarkMode
                          ? const Color(0xFFD6D6D6)
                          : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, //
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.isDarkMode
                          ? const Color(0xFFD6D6D6)
                          : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Row(
              children: [
                Text(
                  song.duration.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: context.isDarkMode
                        ? const Color(0xFFD6D6D6)
                        : Colors.black,
                  ),
                ),
                action ?? Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
