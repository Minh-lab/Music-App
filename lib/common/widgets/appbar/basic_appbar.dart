import 'package:flutter/material.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/actions/switch_theme_mode.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  // final bool hideBack;
  final bool enableChangeTheme;

  const BasicAppBar({
    this.title,
    // this.hideBack = false,
    this.enableChangeTheme = false,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: title ?? const Text(''),
      centerTitle: true,
      backgroundColor: (context.isDarkMode) ? AppColors.dartBackground : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      // leading: (hideBack)
      //     ? IconButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         icon: Container(
      //           // padding: const EdgeInsets.all(20),
      //           height: 50,
      //           width: 50,
      //           decoration: (hideBack)
      //               ? null
      //               : BoxDecoration(
      //                   color: context.isDarkMode
      //                       ? Colors.white.withValues(alpha: 0.03)
      //                       : Colors.black.withValues(alpha: 0.04),
      //                   shape: BoxShape.circle,
      //                 ),              ),
      //       )
      //     : IconButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         icon: Container(
      //           // padding: const EdgeInsets.all(20),
      //           height: 50,
      //           width: 50,
      //           decoration: BoxDecoration(
      //             color: context.isDarkMode
      //                 ? Colors.white.withValues(alpha: 0.03)
      //                 : Colors.black.withValues(alpha: 0.04),
      //             shape: BoxShape.circle,
      //           ),
      //           child: Center(child: Icon(Icons.arrow_back_ios_new, size: 15)),
      //         ),
      //       ),
      actions: [if (enableChangeTheme) SwitchThemeMode()],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
