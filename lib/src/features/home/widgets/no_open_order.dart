import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';

class NoOpenOrder extends StatelessWidget {
  const NoOpenOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 48.h),
      child: Column(
        children: [
          Text('No Open Orders', style: AppTextStyles.headlineOne),
          SizedBox(height: 8.h),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Id pulvinar nullam sit imperdiet pulvinar.',
            style: AppTextStyles.bodyTwo,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
