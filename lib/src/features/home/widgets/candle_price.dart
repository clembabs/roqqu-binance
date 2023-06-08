import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/features/home/models/candle_price.dart';

class CandlePrice extends StatelessWidget {
  final String symbol;
  final CandlePriceModel candlePriceModel;
  const CandlePrice({
    super.key,
    required this.symbol,
    required this.candlePriceModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: candlePriceModel.lowPrice != null
          ? Row(
              children: [
                Text(
                  symbol,
                  style: AppTextStyles.outline
                      .copyWith(color: AppColors.blackTintThreeSecondary),
                ),
                SizedBox(width: 16.w),
                Row(
                  children: [
                    Text(
                      'O',
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.blackTintThreeSecondary),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      candlePriceModel.openPrice,
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.successColor),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Row(
                  children: [
                    Text(
                      'H',
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.blackTintThreeSecondary),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      candlePriceModel.highPrice,
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.successColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'L',
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.blackTintThreeSecondary),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      candlePriceModel.lowPrice,
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.successColor),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Row(
                  children: [
                    Text(
                      'C',
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.blackTintThreeSecondary),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      candlePriceModel.closePrice,
                      style: AppTextStyles.outline
                          .copyWith(color: AppColors.successColor),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
