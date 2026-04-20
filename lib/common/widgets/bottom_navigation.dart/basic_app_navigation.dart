import 'package:flutter/material.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';

class BasicAppNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap; 
  const BasicAppNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, 
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        // Màu sắc dựa trên chế độ sáng/tối
        color: context.isDarkMode ? const Color(0xFF343434) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Trải đều icon
        children: [
          _navItem(Icons.home_rounded, 0, ),
          _navItem(Icons.explore_outlined, 1),
          _navItem(Icons.favorite_outline_rounded, 2),
          _navItem(Icons.person_outline_rounded, 3),
        ],
      ),
    );
  }


  Widget _navItem(IconData icon, int index) {
    // So sánh index để biết có đang được chọn hay không
    bool isSelected = selectedIndex == index;

    return IconButton(
      onPressed: () => onTap(index), // Gọi hàm callback khi nhấn
      icon: Icon(
        icon,
        size: 28,
        color: isSelected ? AppColors.primary : Colors.grey,
      ),
    );
  }
}
