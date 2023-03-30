import 'package:flutter/material.dart';
import '../utils/utils.dart'; // import the form_validator package

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int minimumLines;
  final int maximumLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? suffixIcon;

  final String? Function(String?)? validator;
  final ValueChanged<String> onChanged;
  // require a validator function argument

  const CustomTextField({
    this.suffixIcon,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.minimumLines = 1,
    this.maximumLines = 1,
    this.keyboardType = TextInputType.name,
    required this.validator, // validate must be required in the constructor
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: AppColors.primary),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: AppColors.errorColor),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.primary, //<-- SEE HERE
        ),
      ),
      style: const TextStyle(color: AppColors.primary),
      cursorColor: AppColors.primary,
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator, // apply the given validator
      keyboardType: keyboardType,
      minLines: minimumLines, //Normal textInputField will be displayed
      maxLines: maximumLines, // when user presses enter it will adapt to it
    );
  }
}
