import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/circle_process/circle_process.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/core/configs/constants/app_urls.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/bloc/news_song_state.dart';
import 'package:spotify_me/presentation/home/bloc/news_songs_cubit.dart';
import 'package:spotify_me/presentation/home/bloc/play_song_cubit.dart';
import 'package:spotify_me/presentation/home/bloc/play_song_state.dart';
import 'package:spotify_me/presentation/home/widgets/PlaySongPages/pages/play_song.dart';
import 'package:spotify_me/presentation/home/widgets/play_song_button.dart';

class NewsSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 300,
        child: BlocBuilder<NewsSongsCubit, NewsSongState>(
          builder: (context, state) {
            if (state is NewsSongLoading) {
              return CircleProcess();
            }
            if (state is NewsSongLoaded) {
              return _songs(state.songs);
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final song = songs[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaySong(songEntity: song),
              ),
            );
          },
          child: Stack(
            children: [
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                          image: song.coverUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(song.coverUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: song.coverUrl == null
                            ? const Icon(
                                Icons.music_note,
                                size: 48,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //icon play song
              Positioned(
                bottom: 100,
                right: 2,
                child: Container(
                  width: 40,
                  height: 40,
                  transform: Matrix4.translationValues(10, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode
                        ? AppColors.grayDark
                        : const Color(0xFFE6E6E6),
                  ),
                  child: PlaySongButton(context, song),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 35),
      itemCount: songs.length,
    );
  }

   
}
