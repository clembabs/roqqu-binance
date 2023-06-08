import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/features/home/models/candle_price.dart';
import 'package:roqqu_binance/src/features/home/models/candle_ticker_model.dart';
import 'package:roqqu_binance/src/features/home/models/symbols.dart';
import 'package:roqqu_binance/src/features/home/widgets/balance_header.dart';
import 'package:roqqu_binance/src/features/home/widgets/candles_view.dart';
import 'package:roqqu_binance/src/features/home/widgets/card_stroke.dart';
import 'package:roqqu_binance/src/features/home/widgets/charts_tabs.dart';
import 'package:roqqu_binance/src/features/home/widgets/header.dart';
import 'package:roqqu_binance/src/features/home/widgets/home_bottom_sheet.dart';
import 'package:roqqu_binance/src/features/home/widgets/orders_tab.dart';
import 'package:roqqu_binance/src/repositories/candles/candles_repository_impl.dart';
import 'package:roqqu_binance/src/widgets/action_button.dart';
import 'package:roqqu_binance/src/widgets/bottom_sheet_container.dart';
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
  List<Candle> onedayCandles = [];
  String currentInterval = "1h";
  CandlePriceModel candlePriceModel = CandlePriceModel();
  bool isLoading = false;
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
      onedayCandles = [];
      currentInterval = interval;
      isLoading = true;
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

        _channel!.stream.listen((data) {
          final jsonData = jsonDecode(data);
          final eventType = jsonData['e'];
          final klineData = jsonData['k'];

          if (eventType == 'kline' && klineData != null) {
            candlePriceModel.openPrice = klineData['o'];
            candlePriceModel.highPrice = klineData['h'];
            candlePriceModel.lowPrice = klineData['l'];
            candlePriceModel.closePrice = klineData['c'];
          }
        });
      });
    } catch (e) {
      return;
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (candles.isEmpty) return;

    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k") == true) {
        final candleTicker = CandleTickerModel.fromJson(map);
        candlePriceModel.openPrice = candleTicker.candle.open;
        candlePriceModel.closePrice = candleTicker.candle.close;
        candlePriceModel.lowPrice = candleTicker.candle.low;
        candlePriceModel.closePrice = candleTicker.candle.close;

        if (candles[0].date == candleTicker.candle.date &&
            candles[0].open == candleTicker.candle.open) {
          candles[0] = candleTicker.candle;
        } else if (candleTicker.candle.date.difference(candles[0].date) ==
            candles[0].date.difference(candles[1].date)) {
          candles.insert(0, candleTicker.candle);
        }
      }
    }
  }

  Future<void> loadMoreCandles() async {
    try {
      final data = await repository.fetchCandles(
          symbol: currentSymbol.symbol,
          interval: currentInterval,
          endTime: candles.last.date.millisecondsSinceEpoch);
      candles.removeLast();
      setState(() {
        candles.addAll(data);
      });
    } catch (e) {
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
                BalanceHeader(
                  symbols: symbols,
                  currentSymbol: currentSymbol,
                  candlePriceModel: candlePriceModel,
                  onSelect: (value) {
                    fetchCandles(value, currentInterval);
                  },
                ),
                const CardStroke(),
                SizedBox(height: 16.h),
                ChartTabs(
                  tabBarView: TabBarView(children: [
                    CandlesView(
                      updateCandlesFromSnapshot: updateCandlesFromSnapshot,
                      currentSymbol: currentSymbol,
                      currentInterval: currentInterval,
                      onLoadMoreCandles: loadMoreCandles(),
                      indicators: indicators,
                      candles: candles,
                      intervals: intervals,
                      candlePriceModel: candlePriceModel,
                      onSelectCandles: (value) {
                        fetchCandles(currentSymbol, value);
                      },
                    ),
                    CandlesView(
                      updateCandlesFromSnapshot: updateCandlesFromSnapshot,
                      currentSymbol: currentSymbol,
                      currentInterval: currentInterval,
                      onLoadMoreCandles: loadMoreCandles(),
                      indicators: indicators,
                      candles: candles,
                      intervals: intervals,
                      candlePriceModel: candlePriceModel,
                      onSelectCandles: (value) {
                        fetchCandles(currentSymbol, value);
                      },
                    ),
                    CandlesView(
                      updateCandlesFromSnapshot: updateCandlesFromSnapshot,
                      currentSymbol: currentSymbol,
                      currentInterval: currentInterval,
                      onLoadMoreCandles: loadMoreCandles(),
                      indicators: indicators,
                      candles: candles,
                      intervals: intervals,
                      candlePriceModel: candlePriceModel,
                      onSelectCandles: (value) {
                        fetchCandles(currentSymbol, value);
                      },
                    ),
                  ]),
                ),
                SizedBox(height: 24.h),
                SizedBox(height: 5.h),
                const OrdersTab(),
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
                  Expanded(
                    child: ActionButton(
                      text: 'Buy',
                      color: AppColors.successColor,
                      onTap: () => const BottomSheetContainer(children: [
                        HomeBottomSheet(),
                      ]).show(context),
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
      )),
    );
  }
}
