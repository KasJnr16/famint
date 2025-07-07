import 'package:fanmint/utility/constants/colors.dart';
import 'package:flutter/material.dart';

class UniCircularLoader extends StatelessWidget {
  const UniCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: UniColors.white,
    );
  }
}
