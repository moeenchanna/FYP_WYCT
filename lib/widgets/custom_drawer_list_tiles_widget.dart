import 'package:flutter/material.dart';

import '../utils/utils.dart';

class DrawerListTiles extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerListTiles({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
      leading: Icon(
        icon,
        color: AppColors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
