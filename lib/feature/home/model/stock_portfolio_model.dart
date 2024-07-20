class StockPortfolioModel {
  String portfolioName;
  List<Stocks> stocks;
  StockPortfolioModel({
    required this.portfolioName,
    required this.stocks,
  });
}

class Stocks {
  String commpanyName;
  double percentage;
  Stocks({
    required this.commpanyName,
    required this.percentage,
  });
}
