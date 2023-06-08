import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';
import 'package:roqqu_binance/src/features/home/widgets/no_open_order.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                        child: const Text('Open Orders'),
                      ),
                      Container(
                        width: 101.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Positions'),
                      ),
                      Container(
                        width: 96.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Order History'),
                      ),
                    ]),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const TabBarView(children: [
                  NoOpenOrder(),
                  NoOpenOrder(),
                  NoOpenOrder(),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
