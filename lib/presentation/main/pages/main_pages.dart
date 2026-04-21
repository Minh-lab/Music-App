import 'package:flutter/material.dart';
import 'package:spotify_me/common/widgets/bottom_navigation.dart/basic_app_navigation.dart';
import 'package:spotify_me/presentation/explore/pages/explore_pages.dart';
import 'package:spotify_me/presentation/favourite/pages/favourite_pages.dart';
import 'package:spotify_me/presentation/home/pages/home.dart';
import 'package:spotify_me/presentation/profile/pages/profile.dart';

class MainPages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainPagesState();
  }

}
class MainPagesState extends State<MainPages> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(), // Tab 0
    ExplorePages(),
    FavouritePages(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BasicAppNavigation(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
