import 'package:flutter/material.dart';
import 'package:timed/utils/app_colors.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final IconData icon;  
  final TextInputType textInputType;
  final bool isObscureText;
  final Widget? rightIcon;

  const RoundTextField({
    super.key,
    this.textEditingController,
    this.validator,
    this.onChanged,
    required this.hintText,
    required this.icon,
    required this.textInputType,
    this.isObscureText = false,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ligitGrayColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            size: 20,
            color: AppColors.grayColor,
          ),
          suffixIcon: rightIcon,
          hintStyle: const TextStyle(fontSize: 12, color: AppColors.grayColor),
        ),
        validator: validator,
      ),
    );
  }
}
