import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static String satoshi = 'Satoshi';

  static TextStyle get headlineOne => TextStyle(
        fontFamily: satoshi,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      );

  static TextStyle get largeMedium => TextStyle(
        fontFamily: satoshi,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        fontSize: 18.sp,
      );

  static TextStyle get bodyOne => headlineOne.copyWith(
        fontSize: 14.sp,
      );

  static TextStyle get subtitleOne => headlineOne.copyWith(
        fontSize: 16.sp,
      );

  static TextStyle get subtitleTwo => largeMedium.copyWith(
        fontSize: 16.sp,
      );

  static TextStyle get bodyTwo => largeMedium.copyWith(
        fontSize: 14.sp,
      );

  static TextStyle get mainCaption => largeMedium.copyWith(
        fontSize: 12.sp,
      );

  static TextStyle get smallCaption => largeMedium.copyWith(
        fontSize: 10.sp,
      );

  static TextStyle get outline => largeMedium.copyWith(
        fontSize: 10.sp,
      );
}
