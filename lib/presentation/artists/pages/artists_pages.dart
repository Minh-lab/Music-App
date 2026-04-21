import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/circle_process/circle_process.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/song_list_tile/song_list_tail.dart';
import 'package:spotify_me/domain/entities/artists/artists_entity.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/artists/bloc/artist_cubit.dart';
import 'package:spotify_me/presentation/artists/bloc/artist_state.dart';

class ArtistsPages extends StatelessWidget {
  final String artistId;
  final String? artistCoverUrl; // Cover URL passed from the list for fallback

  ArtistsPages({super.key, required this.artistId, this.artistCoverUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(hideSearch: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocProvider(
          create: (_) => ArtistCubit()..getArtistById(artistId),
          child: BlocBuilder<ArtistCubit, ArtistState>(
            builder: (context, state) {
              if (state is ArtistGetLoading)
                return Center(child: CircleProcess());
              if (state is ArtistGetFailure)
                return Center(child: Text('Load artist failure'));
              if (state is ArtistGetSuccess) {
                final artist = state.artist;
                // Use the artist's coverUrl, or fallback to the one passed from list
                // final coverUrl = (artist.coverUrl.isNotEmpty)
                //     ? artist.coverUrl
                //     : (artistCoverUrl ?? '');
                return Column(
                  children: [
                    _imageArtist(context, artistCoverUrl!),
                    const SizedBox(height: 16),
                    _inforArtist(artist),
                    const SizedBox(height: 16),
                    _listArtistSongs(artist.listSong),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _imageArtist(BuildContext context, String coverUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: coverUrl.isNotEmpty
            ? Image.network(
                coverUrl,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.person, size: 64, color: Colors.grey),
                  );
                },
              )
            : const Center(
                child: Icon(Icons.person, size: 64, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _inforArtist(ArtistsEntity artist) {
    return Column(
      spacing: 8,
      children: [
        Text(
          artist.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${artist.track} Track${artist.track != 1 ? "s" : ""}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _listArtistSongs(List<SongEntity> listSongs) {
    if (listSongs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Text(
            'No songs available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listSongs.length,
      itemBuilder: (context, index) {
        return SongListTail(context: context, song: listSongs[index]);
      },
    );
  }
}
