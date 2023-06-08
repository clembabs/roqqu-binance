import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';

void showCustomPopupMenu(BuildContext context) {
  final popupMenuItems = [
    PopupMenuItem(
      value: 'option1',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.w),
        child: Text(
          'Exchange',
          style: AppTextStyles.bodyTwo,
        ),
      ),
    ),
    PopupMenuItem(
      value: 'option2',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.w),
        child: Text(
          'Wallets',
          style: AppTextStyles.bodyTwo,
        ),
      ),
    ),
    PopupMenuItem(
      value: 'option3',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.w),
        child: Text(
          'Roqqu Hub',
          style: AppTextStyles.bodyTwo,
        ),
      ),
    ),
    PopupMenuItem(
      value: 'option4',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.w),
        child: Text(
          'Log out ',
          style: AppTextStyles.bodyTwo,
        ),
      ),
    ),
    // Add more PopupMenuItems as needed
  ];

  final RenderBox button = context.findRenderObject() as RenderBox;
  final offset = button.localToGlobal(Offset.zero);

  showMenu(
    color: isLightMode(context)
        ? AppColors.angelWhitePrimary
        : AppColors.darkInputStroke,
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx + button.size.width,
      offset.dy + button.size.height / 5,
      offset.dx,
      offset.dy + button.size.height * 2,
    ),
    items: popupMenuItems,
    elevation: 4,
  ).then((value) {
    // Handle the selected option
    if (value != null) {
      handlePopupMenuSelection(value);
    }
  });
}

void handlePopupMenuSelection(String value) {
  // Handle the selected option
}
