import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CustomInkWellButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CustomInkWellButton({
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(label,style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold
      ),),
    );
  }
}
