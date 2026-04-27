import 'package:flutter/material.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  const BasicAppButton({
    required this.title,
    this.onPressed,
    this.height,
    this.width,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: Size(width ?? double.infinity, height ?? 80),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
