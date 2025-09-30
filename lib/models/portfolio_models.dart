class Portfolio {
  final String userId;
  final double totalValue;
  final double totalGain;
  final double gainPercentage;
  final double cashBalance;
  final List<StockHolding> holdings;
  final DateTime lastUpdated;

  Portfolio({
    required this.userId,
    required this.totalValue,
    required this.totalGain,
    required this.gainPercentage,
    required this.cashBalance,
    required this.holdings,
    required this.lastUpdated,
  });

  factory Portfolio.fromMap(Map<String, dynamic> map) {
    return Portfolio(
      userId: map['userId'] ?? '',
      totalValue: (map['totalValue'] ?? 0.0).toDouble(),
      totalGain: (map['totalGain'] ?? 0.0).toDouble(),
      gainPercentage: (map['gainPercentage'] ?? 0.0).toDouble(),
      cashBalance:
          (map['cashBalance'] ?? 100000.0).toDouble(), // Default starting cash
      holdings: (map['holdings'] as List<dynamic>? ?? [])
          .map((h) => StockHolding.fromMap(Map<String, dynamic>.from(h)))
          .toList(),
      lastUpdated: map['lastUpdated']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalValue': totalValue,
      'totalGain': totalGain,
      'gainPercentage': gainPercentage,
      'cashBalance': cashBalance,
      'holdings': holdings.map((h) => h.toMap()).toList(),
      'lastUpdated': lastUpdated,
    };
  }

  Portfolio copyWith({
    String? userId,
    double? totalValue,
    double? totalGain,
    double? gainPercentage,
    double? cashBalance,
    List<StockHolding>? holdings,
    DateTime? lastUpdated,
  }) {
    return Portfolio(
      userId: userId ?? this.userId,
      totalValue: totalValue ?? this.totalValue,
      totalGain: totalGain ?? this.totalGain,
      gainPercentage: gainPercentage ?? this.gainPercentage,
      cashBalance: cashBalance ?? this.cashBalance,
      holdings: holdings ?? this.holdings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class StockHolding {
  final String symbol;
  final String name;
  final int shares;
  final double avgPrice;
  final double currentPrice;
  final double totalValue;
  final double gain;
  final double gainPercent;
  final bool isPositive;
  final DateTime lastUpdated;

  StockHolding({
    required this.symbol,
    required this.name,
    required this.shares,
    required this.avgPrice,
    required this.currentPrice,
    required this.totalValue,
    required this.gain,
    required this.gainPercent,
    required this.isPositive,
    required this.lastUpdated,
  });

  factory StockHolding.fromMap(Map<String, dynamic> map) {
    final shares = (map['shares'] ?? 0).toInt();
    final avgPrice = (map['avgPrice'] ?? 0.0).toDouble();
    final currentPrice = (map['currentPrice'] ?? 0.0).toDouble();
    final totalValue = shares * currentPrice;
    final gain = (currentPrice - avgPrice) * shares;
    final gainPercent =
        avgPrice > 0 ? ((currentPrice - avgPrice) / avgPrice) * 100 : 0.0;

    return StockHolding(
      symbol: map['symbol'] ?? '',
      name: map['name'] ?? '',
      shares: shares,
      avgPrice: avgPrice,
      currentPrice: currentPrice,
      totalValue: totalValue,
      gain: gain,
      gainPercent: gainPercent,
      isPositive: currentPrice >= avgPrice,
      lastUpdated: map['lastUpdated']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'name': name,
      'shares': shares,
      'avgPrice': avgPrice,
      'currentPrice': currentPrice,
      'totalValue': totalValue,
      'gain': gain,
      'gainPercent': gainPercent,
      'isPositive': isPositive,
      'lastUpdated': lastUpdated,
    };
  }

  StockHolding copyWith({
    String? symbol,
    String? name,
    int? shares,
    double? avgPrice,
    double? currentPrice,
    DateTime? lastUpdated,
  }) {
    final newShares = shares ?? this.shares;
    final newAvgPrice = avgPrice ?? this.avgPrice;
    final newCurrentPrice = currentPrice ?? this.currentPrice;
    final newTotalValue = newShares * newCurrentPrice;
    final newGain = (newCurrentPrice - newAvgPrice) * newShares;
    final newGainPercent = newAvgPrice > 0
        ? ((newCurrentPrice - newAvgPrice) / newAvgPrice) * 100
        : 0.0;

    return StockHolding(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      shares: newShares,
      avgPrice: newAvgPrice,
      currentPrice: newCurrentPrice,
      totalValue: newTotalValue,
      gain: newGain,
      gainPercent: newGainPercent,
      isPositive: newCurrentPrice >= newAvgPrice,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }
}

class Transaction {
  final String id;
  final String userId;
  final String symbol;
  final String stockName;
  final TransactionType type;
  final int shares;
  final double price;
  final double totalAmount;
  final DateTime timestamp;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.stockName,
    required this.type,
    required this.shares,
    required this.price,
    required this.totalAmount,
    required this.timestamp,
    required this.status,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      symbol: map['symbol'] ?? '',
      stockName: map['stockName'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => TransactionType.buy,
      ),
      shares: (map['shares'] ?? 0).toInt(),
      price: (map['price'] ?? 0.0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => TransactionStatus.completed,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'symbol': symbol,
      'stockName': stockName,
      'type': type.toString().split('.').last,
      'shares': shares,
      'price': price,
      'totalAmount': totalAmount,
      'timestamp': timestamp,
      'status': status.toString().split('.').last,
    };
  }
}

enum TransactionType {
  buy,
  sell,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class TradeOrder {
  final String symbol;
  final String stockName;
  final TransactionType type;
  final int shares;
  final double price;
  final double totalAmount;

  TradeOrder({
    required this.symbol,
    required this.stockName,
    required this.type,
    required this.shares,
    required this.price,
  }) : totalAmount = shares * price;

  bool get isBuy => type == TransactionType.buy;
  bool get isSell => type == TransactionType.sell;

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'stockName': stockName,
      'type': type.toString().split('.').last,
      'shares': shares,
      'price': price,
      'totalAmount': totalAmount,
    };
  }
}
