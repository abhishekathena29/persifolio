import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/portfolio_models.dart';

class TransactionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get _userId => _auth.currentUser?.uid ?? '123456790';

  /// Execute a buy order
  static Future<TransactionResult> executeBuyOrder(TradeOrder order) async {
    if (_userId.isEmpty) {
      return TransactionResult.failure('User not authenticated');
    }

    try {
      // Start a Firestore transaction to ensure data consistency
      return await _firestore
          .runTransaction<TransactionResult>((transaction) async {
        // Get current portfolio
        final portfolioRef = _firestore.collection('portfolios').doc(_userId);
        final portfolioDoc = await transaction.get(portfolioRef);

        Portfolio portfolio;
        if (portfolioDoc.exists) {
          portfolio = Portfolio.fromMap(portfolioDoc.data()!);
        } else {
          // Create new portfolio with default cash balance
          portfolio = Portfolio(
            userId: _userId,
            totalValue: 100000.0, // Starting cash
            totalGain: 0.0,
            gainPercentage: 0.0,
            cashBalance: 100000.0,
            holdings: [],
            lastUpdated: DateTime.now(),
          );
        }

        // Check if user has enough cash
        if (portfolio.cashBalance < order.totalAmount) {
          return TransactionResult.failure(
              'Insufficient cash balance. Available: ₹${portfolio.cashBalance.toStringAsFixed(2)}, Required: ₹${order.totalAmount.toStringAsFixed(2)}');
        }

        // Update or create holding
        final updatedHoldings = List<StockHolding>.from(portfolio.holdings);
        final existingIndex =
            updatedHoldings.indexWhere((h) => h.symbol == order.symbol);

        if (existingIndex >= 0) {
          // Update existing holding
          final existing = updatedHoldings[existingIndex];
          final newShares = existing.shares + order.shares;
          final newAvgPrice =
              ((existing.avgPrice * existing.shares) + order.totalAmount) /
                  newShares;

          updatedHoldings[existingIndex] = existing.copyWith(
            shares: newShares,
            avgPrice: newAvgPrice,
            currentPrice: order.price,
          );
        } else {
          // Create new holding
          updatedHoldings.add(StockHolding(
            symbol: order.symbol,
            name: order.stockName,
            shares: order.shares,
            avgPrice: order.price,
            currentPrice: order.price,
            totalValue: order.totalAmount,
            gain: 0.0,
            gainPercent: 0.0,
            isPositive: true,
            lastUpdated: DateTime.now(),
          ));
        }

        // Calculate new portfolio values
        final newCashBalance = portfolio.cashBalance - order.totalAmount;
        final newTotalValue =
            _calculateTotalValue(updatedHoldings) + newCashBalance;
        final newTotalGain = _calculateTotalGain(updatedHoldings);
        final newGainPercentage = _calculateGainPercentage(
            newTotalValue, newTotalGain, newCashBalance);

        // Update portfolio
        final updatedPortfolio = portfolio.copyWith(
          totalValue: newTotalValue,
          totalGain: newTotalGain,
          gainPercentage: newGainPercentage,
          cashBalance: newCashBalance,
          holdings: updatedHoldings,
          lastUpdated: DateTime.now(),
        );

        transaction.set(portfolioRef, updatedPortfolio.toMap());

        // Create transaction record
        final transactionRecord = Transaction(
          id: _firestore.collection('transactions').doc().id,
          userId: _userId,
          symbol: order.symbol,
          stockName: order.stockName,
          type: TransactionType.buy,
          shares: order.shares,
          price: order.price,
          totalAmount: order.totalAmount,
          timestamp: DateTime.now(),
          status: TransactionStatus.completed,
        );

        final transactionRef =
            _firestore.collection('transactions').doc(transactionRecord.id);
        transaction.set(transactionRef, transactionRecord.toMap());

        return TransactionResult.success(
          'Successfully bought ${order.shares} shares of ${order.symbol} for ₹${order.totalAmount.toStringAsFixed(2)}',
          transactionRecord,
        );
      });
    } catch (e) {
      print('Error executing buy order: $e');
      return TransactionResult.failure(
          'Failed to execute buy order: ${e.toString()}');
    }
  }

  /// Execute a sell order
  static Future<TransactionResult> executeSellOrder(TradeOrder order) async {
    if (_userId.isEmpty) {
      return TransactionResult.failure('User not authenticated');
    }

    try {
      return await _firestore
          .runTransaction<TransactionResult>((transaction) async {
        // Get current portfolio
        final portfolioRef = _firestore.collection('portfolios').doc(_userId);
        final portfolioDoc = await transaction.get(portfolioRef);

        if (!portfolioDoc.exists) {
          return TransactionResult.failure('Portfolio not found');
        }

        final portfolio = Portfolio.fromMap(portfolioDoc.data()!);

        // Find the holding
        final holdingIndex =
            portfolio.holdings.indexWhere((h) => h.symbol == order.symbol);
        if (holdingIndex == -1) {
          return TransactionResult.failure('Stock not found in portfolio');
        }

        final holding = portfolio.holdings[holdingIndex];

        // Check if user has enough shares
        if (holding.shares < order.shares) {
          return TransactionResult.failure(
              'Insufficient shares. Available: ${holding.shares}, Required: ${order.shares}');
        }

        // Update holdings
        final updatedHoldings = List<StockHolding>.from(portfolio.holdings);
        final remainingShares = holding.shares - order.shares;

        if (remainingShares == 0) {
          // Remove holding completely
          updatedHoldings.removeAt(holdingIndex);
        } else {
          // Update holding with remaining shares
          updatedHoldings[holdingIndex] = holding.copyWith(
            shares: remainingShares,
            currentPrice: order.price,
          );
        }

        // Calculate new portfolio values
        final newCashBalance = portfolio.cashBalance + order.totalAmount;
        final newTotalValue =
            _calculateTotalValue(updatedHoldings) + newCashBalance;
        final newTotalGain = _calculateTotalGain(updatedHoldings);
        final newGainPercentage = _calculateGainPercentage(
            newTotalValue, newTotalGain, newCashBalance);

        // Update portfolio
        final updatedPortfolio = portfolio.copyWith(
          totalValue: newTotalValue,
          totalGain: newTotalGain,
          gainPercentage: newGainPercentage,
          cashBalance: newCashBalance,
          holdings: updatedHoldings,
          lastUpdated: DateTime.now(),
        );

        transaction.set(portfolioRef, updatedPortfolio.toMap());

        // Create transaction record
        final transactionRecord = Transaction(
          id: _firestore.collection('transactions').doc().id,
          userId: _userId,
          symbol: order.symbol,
          stockName: order.stockName,
          type: TransactionType.sell,
          shares: order.shares,
          price: order.price,
          totalAmount: order.totalAmount,
          timestamp: DateTime.now(),
          status: TransactionStatus.completed,
        );

        final transactionRef =
            _firestore.collection('transactions').doc(transactionRecord.id);
        transaction.set(transactionRef, transactionRecord.toMap());

        return TransactionResult.success(
          'Successfully sold ${order.shares} shares of ${order.symbol} for ₹${order.totalAmount.toStringAsFixed(2)}',
          transactionRecord,
        );
      });
    } catch (e) {
      print('Error executing sell order: $e');
      return TransactionResult.failure(
          'Failed to execute sell order: ${e.toString()}');
    }
  }

  /// Get user's transaction history
  static Future<List<Transaction>> getTransactionHistory(
      {int limit = 50}) async {
    if (_userId.isEmpty) return [];

    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: _userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Transaction.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting transaction history: $e');
      return [];
    }
  }

  /// Get transactions for a specific stock
  static Future<List<Transaction>> getStockTransactions(String symbol) async {
    if (_userId.isEmpty) return [];

    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: _userId)
          .where('symbol', isEqualTo: symbol)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Transaction.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting stock transactions: $e');
      return [];
    }
  }

  /// Check if user can sell a specific stock
  static Future<SellValidationResult> validateSellOrder(
      String symbol, int shares) async {
    if (_userId.isEmpty) {
      return SellValidationResult(false, 0, 'User not authenticated');
    }

    try {
      final portfolioDoc =
          await _firestore.collection('portfolios').doc(_userId).get();

      if (!portfolioDoc.exists) {
        return SellValidationResult(false, 0, 'Portfolio not found');
      }

      final portfolio = Portfolio.fromMap(portfolioDoc.data()!);
      final holding = portfolio.holdings.firstWhere(
        (h) => h.symbol == symbol,
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

      if (holding.symbol.isEmpty) {
        return SellValidationResult(false, 0, 'Stock not found in portfolio');
      }

      if (holding.shares < shares) {
        return SellValidationResult(
          false,
          holding.shares,
          'Insufficient shares. Available: ${holding.shares}, Required: $shares',
        );
      }

      return SellValidationResult(true, holding.shares, 'Valid sell order');
    } catch (e) {
      print('Error validating sell order: $e');
      return SellValidationResult(false, 0, 'Error validating sell order');
    }
  }

  /// Get portfolio summary
  static Future<Portfolio?> getPortfolio() async {
    if (_userId.isEmpty) return null;

    try {
      final portfolioDoc =
          await _firestore.collection('portfolios').doc(_userId).get();

      if (!portfolioDoc.exists) {
        // Create default portfolio
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

      return Portfolio.fromMap(portfolioDoc.data()!);
    } catch (e) {
      print('Error getting portfolio: $e');
      return null;
    }
  }

  // Helper methods
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
}

class TransactionResult {
  final bool isSuccess;
  final String message;
  final Transaction? transaction;

  TransactionResult._(this.isSuccess, this.message, this.transaction);

  factory TransactionResult.success(String message, Transaction transaction) {
    return TransactionResult._(true, message, transaction);
  }

  factory TransactionResult.failure(String message) {
    return TransactionResult._(false, message, null);
  }
}

class SellValidationResult {
  final bool isValid;
  final int availableShares;
  final String message;

  SellValidationResult(this.isValid, this.availableShares, this.message);
}
