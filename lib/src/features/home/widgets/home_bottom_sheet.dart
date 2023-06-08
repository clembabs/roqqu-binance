import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/widgets/action_button.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ActionButton.outline(
              text: 'Buy',
              height: 32.h,
              width: 161.w,
              borderColor: AppColors.successColor,
            ),
            SizedBox(width: 5.w),
            ActionButton.outline(
              text: 'Sell',
              height: 32.h,
              width: 161.w,
              borderColor: Colors.transparent,
            ),
          ],
        ),
        ActionButton.outline(
          text: 'Sell',
          height: 32.h,
          width: 80.w,
          color: AppColors.blueFountain,
        ),
      ],
    );
  }
}
