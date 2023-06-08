import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/features/home/models/candle_price.dart';
import 'package:roqqu_binance/src/features/home/models/symbols.dart';
import 'package:roqqu_binance/src/features/home/widgets/candle_price.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final selectedIntervalIndexProvider = StateProvider<int>((ref) => 0);

class CandlesView extends ConsumerStatefulWidget {
  final WebSocketChannel? channel;
  final Function(AsyncSnapshot<Object?> snapshot) updateCandlesFromSnapshot;
  final dynamic onLoadMoreCandles;
  final Function(String) onSelectCandles;
  final Symbols currentSymbol;
  final String currentInterval;
  final List<Indicator> indicators;
  final List<Candle> candles;
  final List<String> intervals;
  final CandlePriceModel candlePriceModel;
  const CandlesView({
    super.key,
    this.channel,
    required this.updateCandlesFromSnapshot,
    this.onLoadMoreCandles,
    required this.onSelectCandles,
    required this.currentSymbol,
    required this.currentInterval,
    required this.indicators,
    required this.candles,
    required this.intervals,
    required this.candlePriceModel,
  });

  @override
  ConsumerState<CandlesView> createState() => _CandlesViewState();
}

class _CandlesViewState extends ConsumerState<CandlesView> {
  @override
  Widget build(BuildContext context) {
    final selectedIntervalIndex = ref.watch(selectedIntervalIndexProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 375.h,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 25.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Time',
                      style: AppTextStyles.bodyTwo
                          .copyWith(color: AppColors.blackTintThreeSecondary),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.intervals.length,
                      itemBuilder: (context, index) {
                        final timeInterval = widget.intervals[index];
                        final isSelected = index == selectedIntervalIndex;
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedIntervalIndexProvider.notifier)
                                .state = index;
                            widget.onSelectCandles(timeInterval);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.blackTintTwoSecondary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              timeInterval.toUpperCase(),
                              style: AppTextStyles.bodyTwo.copyWith(
                                  color: isSelected
                                      ? AppColors.angelWhitePrimary
                                      : AppColors.blackTintThreeSecondary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
              child: CandlePrice(
                symbol: widget.currentSymbol.symbol,
                candlePriceModel: widget.candlePriceModel,
              ),
            ),
            Flexible(
              child: Center(
                child: StreamBuilder(
                  stream:
                      widget.channel == null ? null : widget.channel!.stream,
                  builder: (context, snapshot) {
                    widget.updateCandlesFromSnapshot(snapshot);
                    return Candlesticks(
                      key: Key(
                          widget.currentSymbol.symbol + widget.currentInterval),
                      indicators: widget.indicators,
                      candles: widget.candles,
                      onLoadMoreCandles: () async {
                        widget.onLoadMoreCandles();
                      },
                      onRemoveIndicator: (String indicator) {
                        setState(() {
                          var setIndicators = widget.indicators;
                          setIndicators = [...widget.indicators];
                          setIndicators.removeWhere(
                              (element) => element.name == indicator);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
