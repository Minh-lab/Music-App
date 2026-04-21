import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/song_list_tile/song_list_tail.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_cubit.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_state.dart';
import 'package:spotify_me/service_locator.dart';

class FavouritePages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        hideSearch: false,
        title: Text('My Favourite', style: TextStyle()),
      ),
      body: BlocProvider.value(
        value: sl<FavouriteCubit>()..getFavourite(),
        child: BlocConsumer<FavouriteCubit, FavouriteState>(
          builder: (context, state) {
            if (state is FavouriteLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FavouriteFailure) {
              return const Center(
                child: Text(
                  'Load failure',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is FavouriteLoaded) {
              final List<SongEntity> songs = state.list ?? [];

              if (songs.isEmpty) {
                return const Center(
                  child: Text('Danh sách yêu thích đang trống.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return SongListTail(
                    context: context,
                    song: songs[index],
                    action: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (bottomSheetContext) {
                            return Container(
                              width: double.infinity,
                              // height: 100,
                              child: Column(
                                spacing: 16,
                                children: [
                                  _bottomSheetAction(
                                    Icon(Icons.download_done_outlined),
                                    'Dowload',
                                    () {},
                                  ),
                                  _bottomSheetAction(
                                    Icon(Icons.delete_outline),
                                    'Remove',
                                    () async {
                                      Navigator.pop(
                                        bottomSheetContext,
                                      ); // đóng bottom sheet trước

                                      await context
                                          .read<FavouriteCubit>()
                                          .removeFavourite(songs[index].id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_horiz_outlined),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Unknown state'));
          },
          listener: (BuildContext context, FavouriteState state) {
            if (state is FavouriteRemoveSuccess) {
              var snackbar = new SnackBar(
                content: Text('Remove song from favourite successfully'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            else if(state is FavouriteRemoveFailure){
                var snackbar = new SnackBar(
                content: Text('Remove song from favourite failure'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
        ),
      ),
    );
  }

  Widget _bottomSheetAction(
    Widget? leadIcon,
    String? title,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [leadIcon ?? Container(), Text(title ?? 'No action')],
          ),
        ),
      ),
    );
  }
}
