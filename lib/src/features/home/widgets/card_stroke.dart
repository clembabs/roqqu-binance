import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';

class CardStroke extends StatelessWidget {
  const CardStroke({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      width: double.infinity,
      color: isLightMode(context)
          ? AppColors.lightCardStroke
          : AppColors.darkCardStroke,
    );
  }
}
