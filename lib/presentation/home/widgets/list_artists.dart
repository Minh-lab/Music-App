import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/circle_process/circle_process.dart';
import 'package:spotify_me/domain/entities/artists/artists_entity.dart';
import 'package:spotify_me/presentation/artists/pages/artists_pages.dart';
import 'package:spotify_me/presentation/home/bloc/artists_cubit/artists_state.dart';
import 'package:spotify_me/presentation/home/bloc/artists_cubit/artsits_cubit.dart';

class ListArtists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtsitsCubit()..getArtists(),
      child: SizedBox(
        height: 300,
        child: BlocBuilder<ArtsitsCubit, ArtistsState>(
          builder: (context, state) {
            if (state is ArtistsLoading) {
              return CircleProcess();
            }
            if (state is ArtistsLoaded) {
              List<ArtistsEntity> listArtists = state.listArtists.reversed
                  .toList();
              return _artist(listArtists);
            }
            if (state is ArtistsLoadFailure) {
              return Text('Error Load Artists');
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _artist(List<ArtistsEntity> artists) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtistsPages(
                  artistId: artist.id,
                  artistCoverUrl: artist.coverUrl,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                      image: artist.coverUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(artist.coverUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: artist.coverUrl.isEmpty
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
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        artist.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   artist.track.toString(),
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //   ),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 35),
      itemCount: artists.length,
    );
  }
}
