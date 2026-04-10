import 'package:flutter/material.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height;
  const BasicAppButton({
    required this.title,
    required this.onPressed,
    this.height,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(title, style: TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),), style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      minimumSize: Size.fromHeight(height ?? 80)
    ),);
  }
}
