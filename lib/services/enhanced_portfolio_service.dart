import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/portfolio_models.dart';
import '../services/alpha_vantage_service.dart';

class EnhancedPortfolioService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get _userId => _auth.currentUser?.uid ?? '';

  /// Get user's complete portfolio with real-time price updates
  static Future<Portfolio?> getPortfolioWithLivePrices() async {
    if (_userId.isEmpty) return null;

    try {
      final portfolioDoc =
          await _firestore.collection('portfolios').doc(_userId).get();

      if (!portfolioDoc.exists) {
        return await _createDefaultPortfolio();
      }

      final portfolio = Portfolio.fromMap(portfolioDoc.data()!);

      // Update prices for all holdings
      final updatedHoldings = <StockHolding>[];
      for (final holding in portfolio.holdings) {
        try {
          final quote = await AlphaVantageService.getStockQuote(holding.symbol);
          updatedHoldings.add(holding.copyWith(
            currentPrice: quote['price'],
          ));

          // Add small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          print('Error updating price for ${holding.symbol}: $e');
          // Keep the existing holding with last known price
          updatedHoldings.add(holding);
        }
      }

      // Calculate updated portfolio values
      final totalValue =
          _calculateTotalValue(updatedHoldings) + portfolio.cashBalance;
      final totalGain = _calculateTotalGain(updatedHoldings);
      final gainPercentage = _calculateGainPercentage(
          totalValue, totalGain, portfolio.cashBalance);

      final updatedPortfolio = portfolio.copyWith(
        totalValue: totalValue,
        totalGain: totalGain,
        gainPercentage: gainPercentage,
        holdings: updatedHoldings,
        lastUpdated: DateTime.now(),
      );

      // Save updated portfolio
      await _firestore
          .collection('portfolios')
          .doc(_userId)
          .set(updatedPortfolio.toMap());

      return updatedPortfolio;
    } catch (e) {
      print('Error getting portfolio with live prices: $e');
      return null;
    }
  }

  /// Get portfolio without price updates (faster)
  static Future<Portfolio?> getPortfolio() async {
    if (_userId.isEmpty) return null;

    try {
      final portfolioDoc =
          await _firestore.collection('portfolios').doc(_userId).get();

      if (!portfolioDoc.exists) {
        return await _createDefaultPortfolio();
      }

      return Portfolio.fromMap(portfolioDoc.data()!);
    } catch (e) {
      print('Error getting portfolio: $e');
      return null;
    }
  }

  /// Update a specific stock's price in the portfolio
  static Future<bool> updateStockPrice(String symbol, double newPrice) async {
    if (_userId.isEmpty) return false;

    try {
      return await _firestore.runTransaction<bool>((transaction) async {
        final portfolioRef = _firestore.collection('portfolios').doc(_userId);
        final portfolioDoc = await transaction.get(portfolioRef);

        if (!portfolioDoc.exists) return false;

        final portfolio = Portfolio.fromMap(portfolioDoc.data()!);
        final updatedHoldings = portfolio.holdings.map((holding) {
          if (holding.symbol == symbol) {
            return holding.copyWith(currentPrice: newPrice);
          }
          return holding;
        }).toList();

        final totalValue =
            _calculateTotalValue(updatedHoldings) + portfolio.cashBalance;
        final totalGain = _calculateTotalGain(updatedHoldings);
        final gainPercentage = _calculateGainPercentage(
            totalValue, totalGain, portfolio.cashBalance);

        final updatedPortfolio = portfolio.copyWith(
          totalValue: totalValue,
          totalGain: totalGain,
          gainPercentage: gainPercentage,
          holdings: updatedHoldings,
          lastUpdated: DateTime.now(),
        );

        transaction.set(portfolioRef, updatedPortfolio.toMap());
        return true;
      });
    } catch (e) {
      print('Error updating stock price: $e');
      return false;
    }
  }

  /// Get specific stock holding
  static Future<StockHolding?> getStockHolding(String symbol) async {
    if (_userId.isEmpty) return null;

    try {
      final portfolio = await getPortfolio();
      if (portfolio == null) return null;

      return portfolio.holdings.firstWhere(
        (holding) => holding.symbol == symbol,
        orElse: () => StockHolding(
          symbol: '',
          name: '',
          shares: 0,
          avgPrice: 0.0,
          currentPrice: 0.0,
          totalValue: 0.0,
          gain: 0.0,
          gainPercent: 0.0,
          isPositive: false,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      print('Error getting stock holding: $e');
      return null;
    }
  }

  /// Get portfolio performance statistics
  static Future<PortfolioStats> getPortfolioStats() async {
    try {
      final portfolio = await getPortfolio();
      if (portfolio == null || portfolio.holdings.isEmpty) {
        return PortfolioStats.empty();
      }

      final holdings = portfolio.holdings;

      // Sort by gain percentage
      final sortedHoldings = List<StockHolding>.from(holdings)
        ..sort((a, b) => b.gainPercent.compareTo(a.gainPercent));

      final topPerformer = sortedHoldings.first;
      final worstPerformer = sortedHoldings.last;

      final totalInvested =
          holdings.fold(0.0, (sum, h) => sum + (h.avgPrice * h.shares));
      final totalCurrent = holdings.fold(0.0, (sum, h) => sum + h.totalValue);

      final positiveHoldings = holdings.where((h) => h.isPositive).length;
      final negativeHoldings = holdings.length - positiveHoldings;

      return PortfolioStats(
        totalStocks: holdings.length,
        totalInvested: totalInvested,
        totalCurrent: totalCurrent,
        totalGain: portfolio.totalGain,
        gainPercentage: portfolio.gainPercentage,
        topPerformer: topPerformer,
        worstPerformer: worstPerformer,
        positiveHoldings: positiveHoldings,
        negativeHoldings: negativeHoldings,
        cashBalance: portfolio.cashBalance,
      );
    } catch (e) {
      print('Error getting portfolio stats: $e');
      return PortfolioStats.empty();
    }
  }

  /// Get portfolio diversification data
  static Future<List<SectorAllocation>> getSectorAllocation() async {
    try {
      final portfolio = await getPortfolio();
      if (portfolio == null) return [];

      // Simple sector mapping based on stock symbols
      final sectorMap = <String, double>{};

      for (final holding in portfolio.holdings) {
        final sector = _getSectorFromSymbol(holding.symbol);
        sectorMap[sector] = (sectorMap[sector] ?? 0.0) + holding.totalValue;
      }

      final totalValue = portfolio.totalValue - portfolio.cashBalance;

      return sectorMap.entries.map((entry) {
        return SectorAllocation(
          sector: entry.key,
          value: entry.value,
          percentage: totalValue > 0 ? (entry.value / totalValue) * 100 : 0.0,
        );
      }).toList()
        ..sort((a, b) => b.value.compareTo(a.value));
    } catch (e) {
      print('Error getting sector allocation: $e');
      return [];
    }
  }

  /// Update cash balance (for deposits/withdrawals)
  static Future<bool> updateCashBalance(double newBalance) async {
    if (_userId.isEmpty) return false;

    try {
      return await _firestore.runTransaction<bool>((transaction) async {
        final portfolioRef = _firestore.collection('portfolios').doc(_userId);
        final portfolioDoc = await transaction.get(portfolioRef);

        if (!portfolioDoc.exists) return false;

        final portfolio = Portfolio.fromMap(portfolioDoc.data()!);
        final totalValue =
            _calculateTotalValue(portfolio.holdings) + newBalance;

        final updatedPortfolio = portfolio.copyWith(
          cashBalance: newBalance,
          totalValue: totalValue,
          lastUpdated: DateTime.now(),
        );

        transaction.set(portfolioRef, updatedPortfolio.toMap());
        return true;
      });
    } catch (e) {
      print('Error updating cash balance: $e');
      return false;
    }
  }

  /// Reset portfolio to default state
  static Future<bool> resetPortfolio() async {
    if (_userId.isEmpty) return false;

    try {
      final defaultPortfolio = Portfolio(
        userId: _userId,
        totalValue: 100000.0,
        totalGain: 0.0,
        gainPercentage: 0.0,
        cashBalance: 100000.0,
        holdings: [],
        lastUpdated: DateTime.now(),
      );

      await _firestore
          .collection('portfolios')
          .doc(_userId)
          .set(defaultPortfolio.toMap());
      return true;
    } catch (e) {
      print('Error resetting portfolio: $e');
      return false;
    }
  }

  /// Stream portfolio changes in real-time
  static Stream<Portfolio?> portfolioStream() {
    if (_userId.isEmpty) return Stream.value(null);

    return _firestore
        .collection('portfolios')
        .doc(_userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return Portfolio.fromMap(doc.data()!);
    });
  }

  // Private helper methods
  static Future<Portfolio> _createDefaultPortfolio() async {
    final defaultPortfolio = Portfolio(
      userId: _userId,
      totalValue: 100000.0,
      totalGain: 0.0,
      gainPercentage: 0.0,
      cashBalance: 100000.0,
      holdings: [],
      lastUpdated: DateTime.now(),
    );

    await _firestore
        .collection('portfolios')
        .doc(_userId)
        .set(defaultPortfolio.toMap());
    return defaultPortfolio;
  }

  static double _calculateTotalValue(List<StockHolding> holdings) {
    return holdings.fold(0.0, (sum, holding) => sum + holding.totalValue);
  }

  static double _calculateTotalGain(List<StockHolding> holdings) {
    return holdings.fold(0.0, (sum, holding) => sum + holding.gain);
  }

  static double _calculateGainPercentage(
      double totalValue, double totalGain, double cashBalance) {
    final investedAmount = totalValue - cashBalance - totalGain;
    if (investedAmount <= 0) return 0.0;
    return (totalGain / investedAmount) * 100;
  }

  static String _getSectorFromSymbol(String symbol) {
    // Simple sector mapping based on common Indian stocks
    final sectorMap = {
      'RELIANCE.BSE': 'Energy',
      'TCS.BSE': 'Technology',
      'HDFCBANK.BSE': 'Banking',
      'INFY.BSE': 'Technology',
      'ICICIBANK.BSE': 'Banking',
      'HINDUNILVR.BSE': 'Consumer Goods',
      'ITC.BSE': 'Consumer Goods',
      'SBIN.BSE': 'Banking',
      'BHARTIARTL.BSE': 'Telecommunications',
      'KOTAKBANK.BSE': 'Banking',
      'AXISBANK.BSE': 'Banking',
      'ASIANPAINT.BSE': 'Consumer Goods',
      'MARUTI.BSE': 'Automotive',
      'HCLTECH.BSE': 'Technology',
      'SUNPHARMA.BSE': 'Pharmaceuticals',
      'WIPRO.BSE': 'Technology',
      'ULTRACEMCO.BSE': 'Materials',
      'TITAN.BSE': 'Consumer Goods',
      'BAJFINANCE.BSE': 'Financial Services',
      'NESTLEIND.BSE': 'Consumer Goods',
    };

    return sectorMap[symbol] ?? 'Other';
  }
}

class PortfolioStats {
  final int totalStocks;
  final double totalInvested;
  final double totalCurrent;
  final double totalGain;
  final double gainPercentage;
  final StockHolding? topPerformer;
  final StockHolding? worstPerformer;
  final int positiveHoldings;
  final int negativeHoldings;
  final double cashBalance;

  PortfolioStats({
    required this.totalStocks,
    required this.totalInvested,
    required this.totalCurrent,
    required this.totalGain,
    required this.gainPercentage,
    required this.topPerformer,
    required this.worstPerformer,
    required this.positiveHoldings,
    required this.negativeHoldings,
    required this.cashBalance,
  });

  factory PortfolioStats.empty() {
    return PortfolioStats(
      totalStocks: 0,
      totalInvested: 0.0,
      totalCurrent: 0.0,
      totalGain: 0.0,
      gainPercentage: 0.0,
      topPerformer: null,
      worstPerformer: null,
      positiveHoldings: 0,
      negativeHoldings: 0,
      cashBalance: 100000.0,
    );
  }
}

class SectorAllocation {
  final String sector;
  final double value;
  final double percentage;

  SectorAllocation({
    required this.sector,
    required this.value,
    required this.percentage,
  });
}
