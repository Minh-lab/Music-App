import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/helpers/format_duration.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/domain/usecases/favourite/is_song_in_favourite.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_cubit.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_state.dart'
    hide SongInFavourite;
import 'package:spotify_me/presentation/home/widgets/playsong/Bloc/play_song_cubit/play_song_cubit.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/Bloc/play_song_cubit/play_song_state.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/Bloc/song_favourite_cubit.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/Bloc/song_favourite_state.dart';
import 'package:spotify_me/presentation/home/widgets/playsong/pages/play_song_controller.dart';
import 'package:spotify_me/service_locator.dart';

class PlaySong extends StatelessWidget {
  SongEntity? songEntity;
  List<SongEntity> playlist;
  PlaySong({this.songEntity, required this.playlist, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: Text('Now Playing'), enableChangeTheme: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MultiBlocProvider(
          providers: [
     
            BlocProvider.value(value: sl<FavouriteCubit>()),
            BlocProvider(
              create: (_) =>
                  sl<SongFavouriteCubit>()..IsSongInFavourite(songEntity!.id),
            ),
          ],
          child: BlocListener<FavouriteCubit, FavouriteState>(
            listener: (context, songState) {
              if (songState is FavouriteAddSuccess) {
                print('songState đc gọi');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Add song to favourite successfully'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              }
              // else if (songState is FavouriteRemoveSuccess) {
              //   print('xóa');
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text('Remove song from favourite successfully'),
              //     ),
              //   );
              // }
              else if (songState is FavouriteAddFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(songState.errorMessage ?? 'Add failed'),
                  ),
                );
              } else if (songState is FavouriteRemoveFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(songState.errorMessage ?? 'Remove failed'),
                  ),
                );
              }
            },
            child: BlocBuilder<PlaySongCubit, PlaySongState>(
              buildWhen: (previous, current) {
                return current is PlaySongStart ||
                    current is PlaySongPause ||
                    current is PlaySongInitial ||
                    current is PlaySongError;
              },
              builder: (context, songState) {
                print(songState);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 28,
                    ),
                    child: Column(
                      children: [
                        _artistsCard(
                          context,
                          songEntity ??
                              SongEntity(
                                id: 'id',
                                artist: 'artist',
                                duration: Duration(),
                                releaseDate: DateTime.now(),
                                title: 'title',
                              ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // spacing: 40,
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 1.5,
                                  child: _titleSong(
                                    context,
                                    songEntity!.title!,
                                  ),
                                ),
                                SizedBox(height: 8),
                                _artistSong(context, songEntity!.artist),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child:
                                  BlocBuilder<
                                    SongFavouriteCubit,
                                    SongFavouriteState
                                  >(
                                    builder: (context, state) {
                                      return _favouriteButton(
                                        state is SongInFavourite,
                                        () {
                                          print(state);
                                          if (state is SongNotInFavourite) {
                                            context
                                                .read<FavouriteCubit>()
                                                .addFavourite(songEntity!.id);
                                          } else if (state is SongInFavourite) {
                                            context
                                                .read<FavouriteCubit>()
                                                .removeFavourite(
                                                  songEntity!.id,
                                                );
                                          }

                                          // Dùng toggle để cập nhật giao diện (màu nút) tức thời ngầm!
                                          context
                                              .read<SongFavouriteCubit>()
                                              .toggleFavourite();
                                        },
                                      );
                                    },
                                  ),
                            ),
                          ],
                        ),
                        _sliderPlay(context),
                        // more action button
                        SizedBox(height: 20),
                        Stack(
                          children: [
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _previousSongButton(context, () {
                                  int indexPrevious = 0;
                                  int indexCurrent = playlist.indexOf(
                                    songEntity!,
                                  );
                                  if (indexCurrent >= 1 &&
                                      indexCurrent <= playlist.length - 1) {
                                    indexPrevious = indexCurrent - 1;
                                  }
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlaySongController(
                                        playlist: playlist,
                                        songEntity: playlist[indexPrevious],
                                      ),
                                    ),
                                  );
                                }),

                                _playSongButton(songState, () async {
                                  final cubit = context.read<PlaySongCubit>();
                                  // Chỉ set playlist khi chưa có bài (lần đầu bấm Play)
                                  if (cubit.currentSong == null) {
                                    int index = playlist.indexOf(songEntity!);
                                    cubit.playList(playlist, index);
                                  }
                                  await cubit.playOrPause();
                                }),
                                _nextSongButton(context, () {
                                  int indexNext = 0;
                                  int indexCurrent = playlist.indexOf(
                                    songEntity!,
                                  );
                                  if (indexCurrent >= 0 &&
                                      indexCurrent < playlist.length - 1) {
                                    indexNext = indexCurrent + 1;
                                  }
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlaySongController(
                                        playlist: playlist,
                                        songEntity: playlist[indexNext],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            Positioned(
                              bottom: 18,
                              right: 2,
                              child: BlocBuilder<PlaySongCubit, PlaySongState>(
                                buildWhen: (previous, current) {
                                  return current is StartPlayLoop ||
                                      current is StopPlayLoop;
                                },
                                builder: (context, state) {
                                  final bool isLoop = state is StartPlayLoop;
                                  return _loopSongButton(context, isLoop, () {
                                    context.read<PlaySongCubit>().playLoop();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _artistsCard(BuildContext context, SongEntity song) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.2,
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
                  Text(FormatDurationTime.formatDuration(position)),
                  Text(FormatDurationTime.formatDuration(duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _titleSong(BuildContext context, String title) {
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: context.isDarkMode ? const Color(0xFFDFDFDF) : Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold, // SỬA LỖI CÚ PHÁP
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

  Widget _favouriteButton(bool isFavourite, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border_rounded,
        color: isFavourite ? AppColors.primary : null,
      ),
    );
  }

  Widget _playSongButton(PlaySongState state, VoidCallback onPressed) {
    print(state);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(22),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      child: Icon(
        (state is PlaySongStart)
            ? Icons.pause_outlined
            : Icons.play_arrow_outlined,
        size: 50,
        color: Colors.white,
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

  Widget _loopSongButton(
    BuildContext context,
    bool loopSong,
    VoidCallback onPressed,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.loop_outlined,
        size: 40,
        color: (loopSong) ? AppColors.primary : Colors.blueGrey,
      ),
    );
  }
}
