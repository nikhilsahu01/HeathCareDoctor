import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_threeDots_indecator.dart';

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  /// CustomImageView handles SVG, PNG, network, file images with placeholder, tap, alignment, etc.
  const CustomImageView({
    Key? key,
    required this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/appLogoUpdated1.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildImage();

    final decorated = border != null || radius != null
        ? Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: radius,
      ),
      child: radius != null
          ? ClipRRect(borderRadius: radius!, child: imageWidget)
          : imageWidget,
    )
        : imageWidget;

    final tappable = onTap != null ? InkWell(onTap: onTap, child: decorated) : decorated;

    final withMargin = margin != null ? Padding(padding: margin!, child: tappable) : tappable;

    return alignment != null ? Align(alignment: alignment!, child: withMargin) : withMargin;
  }

  Widget _buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return Image.asset(
        placeHolder,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }

    switch (imagePath!.imageType) {
      case ImageType.svg:
        return SvgPicture.asset(
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
      case ImageType.file:
        return Image.file(
          File(imagePath!),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      case ImageType.network:
        return CachedNetworkImage(
          height: height,
          width: width,
          fit: fit,
          imageUrl: imagePath!,
          color: color,
          placeholder: (_, __) => const SizedBox(
            height: 30,
            width: 30,
            child: Center(child: ThreeDotsLoader()),
          ),
          errorWidget: (_, __, ___) => Image.asset(
            placeHolder,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          ),
        );
      case ImageType.png:
      default:
        return Image.asset(
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
    }
  }
}

enum ImageType { svg, png, network, file }

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://') || File(this).existsSync()) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}
