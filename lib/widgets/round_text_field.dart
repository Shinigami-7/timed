import 'package:flutter/material.dart';
import 'package:timed/utils/app_colors.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final IconData icon;  
  final TextInputType textInputType;
  final bool isObsecureText;
  final Widget? rightIcon;

  const RoundTextField(
      {super.key,
      this.textEditingController,
      this.validator,
      this.onChanged,
      required this.hintText,
      required this.icon,
      required this.textInputType,
      this.isObsecureText = false,
      this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: AppColors.ligitGrayColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObsecureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical:15,horizontal: 15 ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,         // here
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: Icon(
              icon,
              size: 20,
              color: AppColors.grayColor,
            ),
          ),
          suffixIcon: rightIcon,
          hintStyle: const TextStyle(fontSize: 12, color : AppColors.grayColor),
        ),
        validator: validator,
      ),
    );
  }
}
