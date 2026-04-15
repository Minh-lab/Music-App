import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/core/configs/assets/app_images.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/home/bloc/news_song_state.dart';
import 'package:spotify_me/presentation/home/bloc/news_songs_cubit.dart';
import 'package:spotify_me/presentation/home/widgets/news_song.dart';
import 'package:spotify_me/presentation/home/widgets/play_song_button.dart';

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
        hideBack: true,
        title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _homeArtistCard(),
            _tabs(),
            SizedBox(
              height: 350,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  NewsSong(),
                  Text('Videos'),
                  Text('Artist'),
                  Text('Podcasts'),
                ],
              ),
            ),
            SizedBox(height: 10),
            _test(context),
          ],
        ),
      ),
    );
  }

  Widget _homeArtistCard() {
    return Center(
      child: Container(
        height: 140,
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: .bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: .bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 100),
                child: Positioned(child: Image.asset(AppImages.homeArtist)),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  // Widget _playlist(BuildContext context){
  //   return
  // }
  Widget _test(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: BlocBuilder<NewsSongsCubit, NewsSongState>(
        builder: (context, state) {
          if (state is NewsSongLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // 1. Tiêu đề Playlist
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Playlist',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Làm to tiêu đề cho đẹp
                          ),
                        ),
                        const Text(
                          'See more',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffC6C6C6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ), // Khoảng cách giữa tiêu đề và danh sách
                  // 2. Danh sách bài hát
                  ListView.builder(
                    padding: EdgeInsets
                        .zero, // Quan trọng: Để zero để không bị lệch với Row ở trên
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      return _songListTile(context, state.songs[index]);
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

  Widget _songListTile(BuildContext context, SongEntity song) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ), // Thay .all(5) bằng vertical để thoáng hơn
      child: Row(
        children: [
          // 1. Nút Play
          GestureDetector(onTap: () {}, child: PlaySongButton(context, song)),
          const SizedBox(width: 10),

          // 2. Phần thông tin bài hát - Dùng Expanded để khống chế chiều rộng
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
                  maxLines: 1, // Bắt buộc phải có
                  overflow: TextOverflow.ellipsis, // Hiện dấu "..." khi tràn
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
                  maxLines: 1, // Bắt buộc phải có
                  overflow: TextOverflow.ellipsis, // Hiện dấu "..." khi tràn
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // 3. Thời lượng và Icon Favorite
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
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_outlined,
                  color: context.isDarkMode
                      ? const Color(0xFF565656)
                      : const Color(0xFFB4B4B4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
