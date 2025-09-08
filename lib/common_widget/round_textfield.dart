import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';

class RoundTextField extends StatelessWidget {
  final String title;
  final Widget suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign titleAlign;
  final bool obscureText;
  final String? value;

  const RoundTextField(
      {super.key,
      required this.title,
      this.titleAlign = TextAlign.left,
      this.controller,
      this.keyboardType,
      this.value,
      this.suffixIcon = const SizedBox.shrink(),
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: titleAlign,
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          validator: (value) => UniValidator.validateEmptyText(title, value),
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(UniSizes.md),
            suffixIcon: suffixIcon,
          ),
        )
      ],
    );
  }
}
