import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';

class ActionButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final TextStyle? style;
  final Widget? widget;

  final bool isDisabled;
  final bool isLoading;

  const ActionButton({
    Key? key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.widget,
    this.textColor,
    this.isLoading = false,
    this.style,
    this.isDisabled = false,
    this.borderColor,
  }) : super(key: key);

  const ActionButton.outline({
    Key? key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.color = Colors.transparent,
    this.widget,
    this.textColor,
    this.isLoading = false,
    this.style,
    this.isDisabled = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: !isDisabled ? onTap : () {},
        child: Container(
          width: width ?? 137.w,
          height: height ?? 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color ?? AppColors.successColor,
              borderRadius: BorderRadius.circular(8),
              border: borderColor != null
                  ? Border.all(color: borderColor ?? AppColors.successColor)
                  : null),
          child: widget ??
              Text(
                text,
                style: style ??
                    AppTextStyles.subtitleOne
                        .copyWith(color: AppColors.angelWhitePrimary),
              ),
        ),
      );
}
