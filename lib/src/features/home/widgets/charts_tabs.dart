import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';

class ChartTabs extends StatelessWidget {
  final TabBarView tabBarView;
  const ChartTabs({super.key, required this.tabBarView});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isLightMode(context)
                      ? AppColors.lightCardStroke
                      : AppColors.darkCardStroke,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                    padding: const EdgeInsets.all(3),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isLightMode(context)
                          ? AppColors.scaffoldLightBackground
                          : const Color(0xFFE9F0FF).withOpacity(.05),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    indicatorPadding: EdgeInsets.zero,
                    unselectedLabelColor: isLightMode(context)
                        ? AppColors.blackTintTwoSecondary
                        : AppColors.angelWhitePrimary,
                    labelColor: isLightMode(context)
                        ? AppColors.rockBlackPrimary
                        : AppColors.angelWhitePrimary,
                    labelStyle: AppTextStyles.bodyTwo,
                    tabs: [
                      Container(
                        width: 102.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Charts'),
                      ),
                      Container(
                        width: 101.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Orderbook'),
                      ),
                      Container(
                        width: 96.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Recent trades'),
                      ),
                    ]),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: tabBarView,
              )
            ],
          ),
        ),
      ),
    );
  }
}
