import 'package:flutter/material.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final String icon;
  final TextInputType textInputType;
  final bool isObsecureText;
  final Widget? rightIcon;

  const RoundTextField(
      {super.key,
      this.textEditingController,
      this.validator,
      this.onChanged,
      required this.icon,
      required this.textInputType,
      required this.isObsecureText,
      this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return  Container(
      
    );
  }
}
