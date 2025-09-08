
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fanmint/common_widget/shimmer.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class UniCircularImage extends StatelessWidget {
  const UniCircularImage({
    super.key,
    this.overlayColor,
    this.backgroundColor,
    this.width = 50,
    this.height = 50,
    this.padding = UniSizes.sm,
    this.fit = BoxFit.cover,
    required this.imageUrl,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String imageUrl;
  final bool isNetworkImage;
  final Color? overlayColor, backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            // if background is null then take effect based on device mode
            (HelperFunctions.isDarkMode(context)
                ? UniColors.black
                : UniColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: isNetworkImage
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: fit,
                color: overlayColor,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    UniShimmerEffect(width: width, height: height, radius: 55),
                errorWidget: (context, url, downloadProgress) =>
                    const Icon(Icons.error),
              )
            : Image(
                fit: fit,
                image: AssetImage(imageUrl) as ImageProvider,
              ),
      ),
    );
  }
}
