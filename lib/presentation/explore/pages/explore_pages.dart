import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/circle_process/circle_process.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/song_list_tile/song_list_tail.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/explore/bloc/search_song_cubit.dart';
import 'package:spotify_me/presentation/explore/bloc/search_song_state.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_cubit.dart';
import 'package:spotify_me/presentation/home/bloc/new_songs_cubit/news_song_state.dart';
import 'package:spotify_me/presentation/home/bloc/new_songs_cubit/news_songs_cubit.dart';
import 'package:spotify_me/service_locator.dart';

class ExplorePages extends StatefulWidget {
  @override
  State<ExplorePages> createState() => _ExplorePagesState();
}

class _ExplorePagesState extends State<ExplorePages> {
  Timer? _debounce; // Khai báo biến Timer
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce
        ?.cancel(); // Nhớ hủy Timer khi thoát màn hình để chống rò rỉ bộ nhớ
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: BasicAppBar(
          title: Text(
            'Explore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Làm to tiêu đề cho đẹp
              color: (context.isDarkMode) ? Color(0xFFDBDBDB) : Colors.black,
            ),
          ),
          // hideBack: true,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => NewsSongsCubit()..getNewsSongs()),
            BlocProvider(create: (_) => SearchSongCubit()),
          ],
          child: BlocBuilder<NewsSongsCubit, NewsSongState>(
            builder: (context, state) {
              if (state is NewsSongLoading) {
                return CircleProcess();
              }
              if (state is NewsSongLoadFailure) {
                return Text('Error!');
              }
              if (state is NewsSongLoaded) {
                final List<SongEntity> defaultSongs = state.songs ?? [];

                return Column(
                  children: [
                    _search(context),
                    Expanded(
                      child: BlocBuilder<SearchSongCubit, SearchSongState>(
                        builder: (context, searchState) {
                          // Đang tải kết quả tìm kiếm
                          if (searchState is SearchSongLoading) {
                            return Center(child: CircleProcess());
                          }

                          // Tìm kiếm thất bại
                          if (searchState is SearchSongFailure) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Không tìm thấy kết quả: ${searchState.errorMessage}',
                                  style: const TextStyle(color: Colors.white54),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          // Có kết quả tìm kiếm
                          if (searchState is SearchSongLoaded) {
                            final searchResults = searchState.songs;
                            if (searchResults.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Không tìm thấy bài hát nào.',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                SongEntity song = searchResults[index];
                                return SongListTail(
                                  context: context,
                                  song: song,
                                  playlist: searchResults,
                                );
                              },
                            );
                          }

                          // Trạng thái ban đầu (SearchSongInitial)  hiển thị danh sách bài hát mới
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: defaultSongs.length,
                            itemBuilder: (context, index) {
                              SongEntity song = defaultSongs[index];
                              return SongListTail(
                                context: context,
                                song: song,
                                playlist: defaultSongs,
                              );
                            },
                          );
                        },
                      ),
                    ),
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

  Widget _search(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ), // Cách đều 2 bên lề
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white), // Màu chữ khi gõ
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900], // Nền xám đen giống Spotify
          hintText: 'Search for artists, songs...',
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white54,
            size: 28,
          ), // Icon kính lúp ở đầu
          // Nút xóa ở cuối ô tìm kiếm (chỉ hiển thị khi có text)
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear, color: Colors.white54),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchSongCubit>().searchSong('');
                },
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Bo tròn nhẹ 4 góc
            borderSide: BorderSide.none, // Xóa viền bao quanh
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
          ), // Căn giữa chữ và icon theo chiều dọc
        ),
        onChanged: (value) {
          // 1. Hủy bỏ cái hẹn giờ cũ nếu người dùng vẫn đang gõ liên tục
          if (_debounce?.isActive ?? false) {
            _debounce!.cancel();
          }

          // 2. Thiết lập hẹn giờ mới: Chờ 500 mili-giây sau lần gõ phím cuối cùng
          _debounce = Timer(const Duration(milliseconds: 500), () {
            // Gọi SearchSongCubit để tìm kiếm (hoặc reset nếu query rỗng)
            context.read<SearchSongCubit>().searchSong(value);
          });
        },
      ),
    );
  }
}
