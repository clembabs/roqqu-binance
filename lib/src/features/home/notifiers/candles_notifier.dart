// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:roqqu_binance/src/core/utilities/view_state.dart';
// import 'package:roqqu_binance/src/features/home/states/candles_state.dart';
// import 'package:roqqu_binance/src/repositories/candles/candle_repository.dart';

// class CandlesNotifier extends StateNotifier<CandlesState> {
//   CandlesNotifier({
//     required this.candlesRepository,
//   }) : super(CandlesState.initial());

//   final CandlesRepository candlesRepository;

//   Future<void> getCandles({
//     required String symbol,
//     required String interval,
//     int? endTime,
//   }) async {
//     state = state.copyWith(viewState: ViewState.loading);

//     final candles = await candlesRepository.fetchCandles(
//       symbol: symbol,
//       interval: interval,
//       endTime: endTime,
//     );

//     state = state.copyWith(candles: candles, viewState: ViewState.idle);
//   }

//   Future<void> getSymbols() async {
//     state = state.copyWith(
//       viewState: ViewState.loading,
//     );

//     final symbols = await candlesRepository.fetchSymbols();

//     state = state.copyWith(
//       symbols: symbols,
//       viewState: ViewState.idle,
//     );
//   }
// }

// final candlesNotifierProvider =
//     StateNotifierProvider<CandlesNotifier, CandlesState>(
//   (ref) => CandlesNotifier(
//     candlesRepository: ref.watch(candleRepositoryProvider),
//   ),
// );
