import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/bottom_navigation.dart/basic_app_navigation.dart';
import 'package:spotify_me/common/widgets/song_list_tile/song_list_tail.dart';
import 'package:spotify_me/core/configs/assets/app_images.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/domain/usecases/favourite/add_favourite_SongUsecase.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_cubit.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_state.dart';
import 'package:spotify_me/presentation/home/bloc/new_songs_cubit/news_song_state.dart';
import 'package:spotify_me/presentation/home/bloc/new_songs_cubit/news_songs_cubit.dart';
import 'package:spotify_me/presentation/home/widgets/list_artists.dart';
import 'package:spotify_me/presentation/home/widgets/news_song.dart';
import 'package:spotify_me/presentation/home/widgets/play_song_button.dart';
import 'package:spotify_me/service_locator.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BasicAppBar(
        enableChangeTheme: true,
        // hideBack: true,
        title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
      ),
      extendBody: true,
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: .center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _homeArtistCard(),
            _tabs(),
            SizedBox(
              height: 350,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [NewsSong(), Text(''), ListArtists(), Text('')],
              ),
            ),
            SizedBox(height: 10),
            _playlist(context),
          ],
        ),
      ),
    );
  }

  // Widget _homeArtistCard() {
  //   return Center(
  //     child: Container(
  //       height: 140,
  //       width: double.infinity,
  //       child: Stack(
  //         children: [
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child: SvgPicture.asset(AppVectors.homeTopCard),
  //           ),
  //           Align(
  //             alignment: .bottomRight,
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 100),
  //               child: Positioned(child: Image.asset(AppImages.homeArtist)),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppColors.primary,
      isScrollable: true,
      dividerColor: Colors.transparent,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      tabs: [
        Text(
          'News',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          'Videos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          'Artists',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          'Podcasts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _playlist(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: BlocBuilder<NewsSongsCubit, NewsSongState>(
        builder: (context, state) {
          if (state is NewsSongLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Playlist',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Làm to tiêu đề cho đẹp
                            color: context.isDarkMode
                                ? Color(0xFFDBDBDB)
                                : Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See more',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.isDarkMode
                                  ? Color(0xFFC6C6C6)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      List<SongEntity> songs = state.songs;
                      return SongListTail(
                        context: context,
                        song: songs[index],
                        playlist: songs,
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
