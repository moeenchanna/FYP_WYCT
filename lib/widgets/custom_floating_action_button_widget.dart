import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: AppColors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.textColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primary,
    );
  }
}
