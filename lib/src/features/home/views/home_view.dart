import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_text_styles.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';
import 'package:roqqu_binance/src/core/constants/svgs.dart';
import 'package:roqqu_binance/src/core/utilities/platform_svg.dart';
import 'package:roqqu_binance/src/features/home/models/candle_ticker_model.dart';
import 'package:roqqu_binance/src/features/home/models/symbols.dart';
import 'package:roqqu_binance/src/features/home/widgets/card_stroke.dart';
import 'package:roqqu_binance/src/features/home/widgets/header.dart';
import 'package:roqqu_binance/src/features/home/widgets/no_open_order.dart';
import 'package:roqqu_binance/src/features/home/widgets/symbol_search.dart';
import 'package:roqqu_binance/src/repositories/candles/candles_repository_impl.dart';
import 'package:roqqu_binance/src/widgets/action_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  CandlesRepositoryImpl repository = CandlesRepositoryImpl();

  WebSocketChannel? _channel;
  List<Candle> candles = [];
  String currentInterval = "1h";
  final intervals = [
    '1h',
    '2h',
    '4h',
    '1d',
    '1w',
    '1M',
  ];
  List<Symbols> symbols = [];
  Symbols currentSymbol = Symbols(symbol: '', price: '');
  List<Indicator> indicators = [
    BollingerBandsIndicator(
      length: 20,
      stdDev: 2,
      upperColor: const Color(0xFF2962FF),
      basisColor: const Color(0xFFFF6D00),
      lowerColor: const Color(0xFF2962FF),
    ),
    WeightedMovingAverageIndicator(
      length: 100,
      color: Colors.green.shade600,
    ),
  ];

  @override
  void initState() {
    fetchSymbols().then((value) {
      symbols = value;
      if (symbols.isNotEmpty) fetchCandles(symbols[0], currentInterval);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_channel != null) _channel!.sink.close();
    super.dispose();
  }

  Future<List<Symbols>> fetchSymbols() async {
    try {
      // load candles info
      final data = await repository.fetchSymbols();
      print(data);
      return data;
    } catch (e) {
      // handle error
      return [];
    }
  }

  Future<void> fetchCandles(Symbols symbol, String interval) async {
    // close current channel if exists
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    // clear last candle list
    setState(() {
      candles = [];
      currentInterval = interval;
    });

    try {
      // load candles info
      final data = await repository.fetchCandles(
          symbol: symbol.symbol, interval: interval);
      // connect to binance stream
      _channel = repository.establishConnection(
          symbol.symbol.toLowerCase(), currentInterval);
      // update candles
      setState(() {
        candles = data;
        currentInterval = interval;
        currentSymbol = symbol;
      });
    } catch (e) {
      // handle error
      return;
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k") == true) {
        final candleTicker = CandleTickerModel.fromJson(map);

        // cehck if incoming candle is an update on current last candle, or a new one
        if (candles[0].date == candleTicker.candle.date &&
            candles[0].open == candleTicker.candle.open) {
          // update last candle
          candles[0] = candleTicker.candle;
        }
        // check if incoming new candle is next candle so the difrence
        // between times must be the same as last existing 2 candles
        else if (candleTicker.candle.date.difference(candles[0].date) ==
            candles[0].date.difference(candles[1].date)) {
          // add new candle to list
          candles.insert(0, candleTicker.candle);
        }
      }
    }
  }

  Future<void> loadMoreCandles() async {
    try {
      // load candles info
      final data = await repository.fetchCandles(
          symbol: currentSymbol.symbol,
          interval: currentInterval,
          endTime: candles.last.date.millisecondsSinceEpoch);
      candles.removeLast();
      setState(() {
        candles.addAll(data);
      });
    } catch (e) {
      // handle error
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(),
                  const CardStroke(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 16.h, left: 16.w, top: 20.h),
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
                                      child:
                                          PlatformSvg.asset(SvgIcons.dollar)),
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
                                      symbols: symbols,
                                      onSelect: (value) {
                                        fetchCandles(value, currentInterval);
                                      },
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    currentSymbol.symbol,
                                    style: AppTextStyles.largeMedium,
                                  ),
                                  SizedBox(width: 20.w),
                                  PlatformSvg.asset(SvgIcons.arrowDown,
                                      color: isLightMode(context)
                                          ? Colors.black
                                          : Colors.white),
                                ],
                              ),
                            ),
                            SizedBox(width: 27.w),
                            if (currentSymbol.price.isNotEmpty)
                              Text(
                                '\$${double.parse(currentSymbol.price)}',
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
                                        color: isLightMode(context)
                                            ? null
                                            : Colors.white),
                                    SizedBox(width: 5.33.w),
                                    Text(
                                      '24h change',
                                      style: AppTextStyles.mainCaption.copyWith(
                                          color: isLightMode(context)
                                              ? AppColors.blackTintTwoSecondary
                                              : AppColors
                                                  .blackTintThreeSecondary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '520.80 +1.25%',
                                  style: AppTextStyles.bodyTwo
                                      .copyWith(color: AppColors.successColor),
                                ),
                              ],
                            ),
                            SizedBox(width: 28.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    PlatformSvg.asset(SvgIcons.arrowUp,
                                        color: isLightMode(context)
                                            ? null
                                            : Colors.white),
                                    SizedBox(width: 5.33.w),
                                    Text(
                                      '24h high',
                                      style: AppTextStyles.mainCaption.copyWith(
                                          color: isLightMode(context)
                                              ? AppColors.blackTintTwoSecondary
                                              : AppColors
                                                  .blackTintThreeSecondary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text('520.80 +1.25%',
                                    style: AppTextStyles.bodyTwo),
                              ],
                            ),
                            SizedBox(width: 28.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    PlatformSvg.asset(SvgIcons.arrowLongDown,
                                        color: isLightMode(context)
                                            ? null
                                            : Colors.white),
                                    SizedBox(width: 5.33.w),
                                    Text(
                                      '24h low',
                                      style: AppTextStyles.mainCaption.copyWith(
                                          color: isLightMode(context)
                                              ? AppColors.blackTintTwoSecondary
                                              : AppColors
                                                  .blackTintThreeSecondary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text('520.80 +1.25%',
                                    style: AppTextStyles.bodyTwo),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const CardStroke(),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  DefaultTabController(
                    length: 3,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              color: isLightMode(context)
                                  ? AppColors.lightCardStroke
                                  : AppColors.darkCardStroke,
                              height: 40.h,
                              alignment: Alignment.center,
                              child: TabBar(
                                  padding: const EdgeInsets.all(3),
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: isLightMode(context)
                                        ? AppColors.scaffoldLightBackground
                                        : const Color(0xFFE9F0FF)
                                            .withOpacity(.05),
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
                            // SizedBox(height: 20.h),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.72,
                            //   child: TabBarView(children: [
                            //     if (customerNotifier.customerData != null)
                            //       AllCustomers(
                            //           customerData: customerNotifier.customerData!),
                            //     if (customerNotifier.owingCustomer != null)
                            //       OwingCustomers(
                            //           owingCustomers:
                            //               customerNotifier.owingCustomer!),
                            //   ]),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    height: 333.h,
                    width: double.infinity,
                    child: Center(
                      child: StreamBuilder(
                        stream: _channel == null ? null : _channel!.stream,
                        builder: (context, snapshot) {
                          updateCandlesFromSnapshot(snapshot);
                          return Candlesticks(
                            key: Key(currentSymbol.symbol + currentInterval),
                            indicators: indicators,
                            candles: candles,
                            onLoadMoreCandles: loadMoreCandles,
                            onRemoveIndicator: (String indicator) {
                              setState(() {
                                indicators = [...indicators];
                                indicators.removeWhere(
                                    (element) => element.name == indicator);
                              });
                            },
                            actions: [
                              ToolBarAction(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          width: 200,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          child: Wrap(
                                            children: intervals
                                                .map((e) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: 50,
                                                        height: 30,
                                                        child:
                                                            RawMaterialButton(
                                                          elevation: 0,
                                                          fillColor:
                                                              const Color(
                                                                  0xFF494537),
                                                          onPressed: () {
                                                            fetchCandles(
                                                                currentSymbol,
                                                                e);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            e,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFFF0B90A),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  currentInterval,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  DefaultTabController(
                    length: 3,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              color: isLightMode(context)
                                  ? AppColors.lightCardStroke
                                  : AppColors.darkCardStroke,
                              height: 40.h,
                              alignment: Alignment.center,
                              child: TabBar(
                                  padding: const EdgeInsets.all(3),
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: isLightMode(context)
                                        ? AppColors.scaffoldLightBackground
                                        : const Color(0xFFE9F0FF)
                                            .withOpacity(.05),
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
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: ActionButton(
                        text: 'Buy',
                        color: AppColors.successColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    const Expanded(
                      child: ActionButton(
                        text: 'Sell',
                        color: AppColors.alertColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
