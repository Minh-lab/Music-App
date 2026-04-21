import 'package:flutter/material.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/actions/switch_theme_mode.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool hideBack;
  final bool hideSearch;
  final bool enableChangeTheme;

  const BasicAppBar({
    this.title,
    this.hideBack = false,
    this.enableChangeTheme = false,
    super.key,
    this.hideSearch = true,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: title ?? const Text(''),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: (hideBack)
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                // padding: const EdgeInsets.all(20),
                height: 50,
                width: 50,
                decoration: (hideBack)
                    ? null
                    : BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.white.withValues(alpha: 0.03)
                            : Colors.black.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                      ),
                child: (hideSearch) ? null : IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined)),
              ),
            )
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                // padding: const EdgeInsets.all(20),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.black.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(Icons.arrow_back_ios_new, size: 15)),
              ),
            ),
      actions: [if (enableChangeTheme) SwitchThemeMode()],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
