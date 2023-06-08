class CandlePriceModel {
  dynamic openPrice;
  dynamic highPrice;
  dynamic lowPrice;
  dynamic closePrice;
  dynamic low24hPrice;
  dynamic high24hPrice;
  dynamic oneDayChange;
  dynamic oneDayLowPercent;
  dynamic oneDayHighPercent;
  dynamic one24hOpen;
  dynamic one24hClose;
  dynamic one24hPrice;
  CandlePriceModel({
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.closePrice,
    this.oneDayChange,
    this.one24hOpen,
    this.one24hClose,
    this.low24hPrice,
    this.high24hPrice,
    this.one24hPrice,
    this.oneDayHighPercent,
    this.oneDayLowPercent,
  });
}
