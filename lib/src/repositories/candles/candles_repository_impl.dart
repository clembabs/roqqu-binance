import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:roqqu_binance/src/core/constants/api_routes.dart';
import 'package:roqqu_binance/src/features/home/models/symbols.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CandlesRepositoryImpl {
  // @override
  Future<List<Candle>> fetchCandles(
      {required String symbol, required String interval, int? endTime}) async {
    try {
      final uri = Uri.parse(
          "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval${endTime != null ? "&endTime=$endTime" : ""}");

      final res = await http.get(uri);

      return (jsonDecode(res.body) as List<dynamic>)
          .map((e) => Candle.fromJson(e))
          .toList()
          .reversed
          .toList();
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return [];
    }
  }

  // @override
  Future<List<Symbols>> fetchSymbols() async {
    try {
      final uri = Uri.parse(ApiRoutes.fetchSymbols);
      final res = await http.get(uri);
      return (jsonDecode(res.body) as List<dynamic>)
          .map((e) => Symbols.fromJson(e))
          .toList()
          .toList();
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return [];
    }
  }

  WebSocketChannel establishConnection(String symbol, String interval) {
    final channel = WebSocketChannel.connect(
      Uri.parse(ApiRoutes.websocketUrl),
    );
    channel.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": ["$symbol@kline_$interval"],
          "id": 1
        },
      ),
    );
    return channel;
  }
}
