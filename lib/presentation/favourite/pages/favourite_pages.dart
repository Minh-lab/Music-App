import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/circle_process/circle_process.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/song_list_tile/song_list_tail.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_cubit.dart';
import 'package:spotify_me/presentation/favourite/bloc/favourite_crud/favourite_state.dart';
import 'package:spotify_me/presentation/favourite/bloc/search_favourite/search_favourite_cubit.dart';
import 'package:spotify_me/presentation/favourite/bloc/search_favourite/search_favourite_state.dart';
import 'package:spotify_me/service_locator.dart';

class FavouritePages extends StatefulWidget {
  @override
  State<FavouritePages> createState() => _FavouritePagesState();
}

class _FavouritePagesState extends State<FavouritePages> {
  Timer? _debounce; // Khai báo biến Timer
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('rebuld');
    return Scaffold(
      appBar: BasicAppBar(
        // hideBack: true,
        title: Text(
          'My Favourite',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Làm to tiêu đề cho đẹp
            color: (context.isDarkMode) ? Color(0xFFDBDBDB) : Colors.black,
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<FavouriteCubit>()..getFavourite()),
          BlocProvider(create: (_) => SearchFavouriteCubit()),
        ],
        child: BlocConsumer<FavouriteCubit, FavouriteState>(
          builder: (context, state) {
            // context.read<FavouriteCubit>().getFavourite();
            if (state is FavouriteLoading) {
              return CircleProcess();
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
              final List<SongEntity> defaultSongs = state.list ?? [];

              if (defaultSongs.isEmpty) {
                return const Center(
                  child: Text('Danh sách yêu thích đang trống.'),
                );
              }
              return Column(
                children: [
                  _search(context),
                  BlocBuilder<SearchFavouriteCubit, SearchFavouriteState>(
                    builder: (context, state) {
                      if (state is SearchFavouriteLoading) {
                        return Center(child: CircleProcess());
                      }
                      if (state is SearchFavouriteFailure) {
                        return Center(child: Text(state.errorMessage!));
                      }
                      if (state is SearchFavouriteSuccess) {
                        List<SongEntity> songSearch = state.listSongs!;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: songSearch.length,
                            itemBuilder: (context, index) {
                              return SongListTail(
                                context: context,
                                song: songSearch[index],
                                playlist: songSearch,
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
                                                Icon(
                                                  Icons.download_done_outlined,
                                                ),
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
                                                      .removeFavourite(
                                                        songSearch[index].id,
                                                      );
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
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: defaultSongs.length,
                          itemBuilder: (context, index) {
                            return SongListTail(
                              context: context,
                              song: defaultSongs[index],
                              playlist: defaultSongs,
                              action: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: context.isDarkMode
                                        ? AppColors.grayDark
                                        : AppColors.lightBackground,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (bottomSheetContext) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          // 3. QUAN TRỌNG: Giúp Bottom Sheet tự động co lại cho vừa khít nội dung, không bị kéo dài lê thê
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 16,
                                            ), // Cách lề trên một chút cho thoáng
                                            _bottomSheetAction(
                                              const Icon(
                                                Icons.download_done_outlined,
                                              ),
                                              'Download',
                                              () {},
                                            ),
                                            _bottomSheetAction(
                                              const Icon(Icons.delete_outline),
                                              'Remove',
                                              () async {
                                                Navigator.pop(
                                                  bottomSheetContext,
                                                ); // đóng bottom sheet trước
                                                await context
                                                    .read<FavouriteCubit>()
                                                    .removeFavourite(
                                                      defaultSongs[index].id,
                                                    );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ), // Cách lề dưới cùng (rất cần thiết trên iPhone dính thanh Home Indicator)
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
                        ),
                      );
                    },
                  ),
                ],
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

              // Nếu đang tìm kiếm thì phải refresh lại danh sách tìm kiếm để cập nhật UI, bắt tìm kiếm lại(refesh)
              if (_searchController.text.isNotEmpty) {
                context.read<SearchFavouriteCubit>().searchSongInFavourite(
                  _searchController.text,
                );
              }
            } else if (state is FavouriteRemoveFailure) {
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
                  context.read<SearchFavouriteCubit>().searchSongInFavourite(
                    '',
                  );
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
          _debounce = Timer(const Duration(milliseconds: 1000), () {
            // Gọi SearchSongCubit để tìm kiếm (hoặc reset nếu query rỗng)
            context.read<SearchFavouriteCubit>().searchSongInFavourite(value);
          });
        },
      ),
    );
  }
}
