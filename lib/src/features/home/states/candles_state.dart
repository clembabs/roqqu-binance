import 'package:candlesticks/candlesticks.dart';
import 'package:roqqu_binance/src/core/utilities/view_state.dart';

class CandlesState {
  final ViewState viewState;
  final List<Candle> candles;
  final List<String> symbols;

  const CandlesState._({
    required this.viewState,
    required this.candles,
    required this.symbols,
  });

  factory CandlesState.initial() => const CandlesState._(
        viewState: ViewState.idle,
        candles: [],
        symbols: [],
      );

  CandlesState copyWith({
    ViewState? viewState,
    List<Candle>? candles,
    List<String>? symbols,
  }) =>
      CandlesState._(
        viewState: viewState ?? this.viewState,
        candles: candles ?? this.candles,
        symbols: symbols ?? this.symbols,
      );
}
