import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/core/configs/assets/app_images.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/presentation/home/widgets/news_song.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _homeArtistCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [NewsSong(), Container(), Container(), Container()],
              ),
            ),
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 41),
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
}
