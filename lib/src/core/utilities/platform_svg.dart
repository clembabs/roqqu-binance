import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlatformSvg {
  static Widget asset(
    String assetName, {
    double? width,
    double? height,
    double maxHeight = 48,
    double maxWidth = 48,
    EdgeInsets? padding,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
    String? semanticsLabel,
    Function()? onTap,
  }) {
    Widget svg = SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        radius: 24,
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: max((maxWidth - (width ?? 0)) / 2, 0),
                vertical: max((maxHeight - (height ?? 0)) / 2, 0),
              ),
          child: svg,
        ),
      );
    }

    if (padding != null) {
      return Padding(
        padding: padding,
        child: svg,
      );
    }

    return svg;
  }
}
