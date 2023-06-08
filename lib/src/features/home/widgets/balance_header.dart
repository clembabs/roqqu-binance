import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';
import 'package:roqqu_binance/src/core/constants/svgs.dart';
import 'package:roqqu_binance/src/core/utilities/platform_svg.dart';
import 'package:roqqu_binance/src/features/home/models/candle_price.dart';
import 'package:roqqu_binance/src/features/home/models/symbols.dart';
import 'package:roqqu_binance/src/features/home/widgets/symbol_search.dart';

String roundToTwoDecimals(double number) {
  if (number != 0.0) {
    final result = number.roundToDouble();
    return result.toString();
  }
  return '';
}

class BalanceHeader extends StatefulWidget {
  final List<Symbols> symbols;
  final Symbols currentSymbol;
  final Function(Symbols) onSelect;
  final CandlePriceModel candlePriceModel;
  const BalanceHeader({
    super.key,
    required this.symbols,
    required this.currentSymbol,
    required this.onSelect,
    required this.candlePriceModel,
  });

  @override
  State<BalanceHeader> createState() => _BalanceHeaderState();
}

class _BalanceHeaderState extends State<BalanceHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h, left: 16.w, top: 20.h),
          child: Row(
            children: [
              SizedBox(
                width: 47.w,
                child: Stack(
                  children: [
                    PlatformSvg.asset(SvgIcons.bitcoin),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: -20,
                        child: PlatformSvg.asset(SvgIcons.dollar)),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SymbolsSearchModal(
                        symbols: widget.symbols,
                        onSelect: widget.onSelect,
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Text(
                      widget.currentSymbol.symbol,
                      style: AppTextStyles.largeMedium,
                    ),
                    SizedBox(width: 20.w),
                    PlatformSvg.asset(SvgIcons.arrowDown,
                        color:
                            isLightMode(context) ? Colors.black : Colors.white),
                  ],
                ),
              ),
              SizedBox(width: 27.w),
              if (widget.currentSymbol.price.isNotEmpty)
                Text(
                  '\$${double.parse(widget.currentSymbol.price)}',
                  style: AppTextStyles.largeMedium
                      .copyWith(color: AppColors.successColor),
                )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 0.w, 14.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlatformSvg.asset(SvgIcons.timer,
                          height: 15.h,
                          width: 13.w,
                          color: isLightMode(context) ? null : Colors.white),
                      SizedBox(width: 5.33.w),
                      Text(
                        '24h change',
                        style: AppTextStyles.mainCaption.copyWith(
                            color: isLightMode(context)
                                ? AppColors.blackTintTwoSecondary
                                : AppColors.blackTintThreeSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  if (widget.candlePriceModel.one24hOpen != null)
                    Text(
                      '${roundToTwoDecimals(widget.candlePriceModel.one24hOpen)}${roundToTwoDecimals(widget.candlePriceModel.oneDayChange)}%',
                      style: AppTextStyles.bodyTwo
                          .copyWith(color: AppColors.successColor),
                    )
                  else
                    Text(
                      ' 520.80 +1.25%',
                      style: AppTextStyles.bodyTwo
                          .copyWith(color: AppColors.successColor),
                    )
                ],
              ),
              SizedBox(width: 28.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlatformSvg.asset(SvgIcons.arrowUp,
                          color: isLightMode(context) ? null : Colors.white),
                      SizedBox(width: 5.33.w),
                      Text(
                        '24h high',
                        style: AppTextStyles.mainCaption.copyWith(
                            color: isLightMode(context)
                                ? AppColors.blackTintTwoSecondary
                                : AppColors.blackTintThreeSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  if (widget.candlePriceModel.high24hPrice != null)
                    Text(
                        '${roundToTwoDecimals(widget.candlePriceModel.high24hPrice)}+${roundToTwoDecimals(widget.candlePriceModel.oneDayHighPercent)}%',
                        style: AppTextStyles.bodyTwo)
                  else
                    Text(
                      ' 520.80 +1.25%',
                      style: AppTextStyles.bodyTwo
                          .copyWith(color: AppColors.successColor),
                    )
                ],
              ),
              SizedBox(width: 28.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlatformSvg.asset(SvgIcons.arrowLongDown,
                          color: isLightMode(context) ? null : Colors.white),
                      SizedBox(width: 5.33.w),
                      Text(
                        '24h low',
                        style: AppTextStyles.mainCaption.copyWith(
                            color: isLightMode(context)
                                ? AppColors.blackTintTwoSecondary
                                : AppColors.blackTintThreeSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  if (widget.candlePriceModel.low24hPrice != null)
                    Text(
                        '${roundToTwoDecimals(widget.candlePriceModel.low24hPrice)}${roundToTwoDecimals(widget.candlePriceModel.oneDayLowPercent)}%',
                        style: AppTextStyles.bodyTwo)
                  else
                    Text(
                      ' 520.80 +1.25%',
                      style: AppTextStyles.bodyTwo
                          .copyWith(color: AppColors.successColor),
                    )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
