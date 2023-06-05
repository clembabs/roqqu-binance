class ApiRoutes {
  ApiRoutes._();

  static const String fetchSymbols =
      "https://api.binance.com/api/v3/ticker/price";

  static const String websocketUrl = 'wss://stream.binance.com:9443/ws';
}
