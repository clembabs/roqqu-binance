import 'dart:convert';

Symbols customerFromJson(String str) => Symbols.fromJson(json.decode(str));

String customerToJson(Symbols data) => json.encode(data.toJson());

class Symbols {
  Symbols({
    required this.symbol,
    required this.price,
  });
  late final String symbol;
  late final String price;

  Symbols.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['price'] = price;
    return data;
  }
}
