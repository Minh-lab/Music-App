import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/core/configs/constants/app_urls.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/bloc/news_song_state.dart';
import 'package:spotify_me/presentation/home/bloc/news_songs_cubit.dart';

class NewsSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit, NewsSongState>(
          builder: (context, state) {
            if (state is NewsSongLoading) {
              return Container(
                alignment: .center,
                child: CircularProgressIndicator(),
              );
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
        return SizedBox(
          width:160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 8),
              Text(
                song.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                song.artist,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 20),
      itemCount: songs.length,
    );
  }
}
