import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
