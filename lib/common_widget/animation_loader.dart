import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UniAnimationLoaderWidget extends StatelessWidget {
  const UniAnimationLoaderWidget({
    super.key,
    this.text,
    this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.height,
    this.width,
    this.color,
    this.lottie,
  });

  final String? text;
  final String? animation, lottie;
  final double? height, width;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(UniSizes.defaultSpace),
      child: Center(
        child: Column(
          children: [
            lottie != null
                ? Lottie.asset(lottie!,
                    width: width ?? MediaQuery.of(context).size.width * 0.6)
                : Center(
                    child: Image.asset(
                      // Display the GIF instead of Lottie animation
                      color: color,
                      animation!,
                      width: width ?? MediaQuery.of(context).size.width * 0.7,
                      height: height,
                    ),
                  ),
            const SizedBox(height: UniSizes.defaultSpace),

            //
            text != null
                ? Text(
                    text!,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  )
                : SizedBox.shrink(),
            const SizedBox(height: UniSizes.defaultSpace),

            //
            showAction
                ? SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(UniColors.dark)),
                      onPressed: onActionPressed,
                      child: Text(
                        actionText!,
                        style:
                            textTheme.bodyMedium!.apply(color: UniColors.light),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
