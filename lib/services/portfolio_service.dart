import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const double _maxInvestmentLimit = 100000.0; // 1 lakh rupees

  static String get _userId => _auth.currentUser?.uid ?? '';

  // Get user portfolio
  static Future<Map<String, dynamic>> getUserPortfolio() async {
    if (_userId.isEmpty) return _getDefaultPortfolio();

    try {
      final doc = await _firestore.collection('portfolios').doc(_userId).get();
      if (doc.exists) {
        final data = doc.data() ?? _getDefaultPortfolio();
        // Ensure all required fields exist
        return _validatePortfolioData(data);
      } else {
        // Create default portfolio for new user
        final defaultPortfolio = _getDefaultPortfolio();
        await _firestore.collection('portfolios').doc(_userId).set(defaultPortfolio);
        return defaultPortfolio;
      }
    } catch (e) {
      print('Error fetching portfolio: $e');
      return _getDefaultPortfolio();
    }
  }

  // Update user portfolio
  static Future<void> updateUserPortfolio(Map<String, dynamic> portfolio) async {
    if (_userId.isEmpty) return;

    try {
      // Validate portfolio data before saving
      final validatedPortfolio = _validatePortfolioData(portfolio);
      await _firestore.collection('portfolios').doc(_userId).set(validatedPortfolio);
    } catch (e) {
      print('Error updating portfolio: $e');
      throw Exception('Failed to update portfolio');
    }
  }

  // Add stock to portfolio with investment limit validation
  static Future<Map<String, dynamic>> addStockToPortfolio(Map<String, dynamic> stock) async {
    if (_userId.isEmpty) return {'success': false, 'message': 'User not authenticated'};

    try {
      // Validate stock data
      if (!_validateStockData(stock)) {
        return {'success': false, 'message': 'Invalid stock data'};
      }

      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      
      // Calculate total investment amount
      final investmentAmount = (stock['shares'] as int) * (stock['avgPrice'] as double);
      final currentTotalInvestment = _calculateTotalInvestment(holdings);
      
      // Check if adding this stock would exceed the limit
      if (currentTotalInvestment + investmentAmount > _maxInvestmentLimit) {
        final availableAmount = _maxInvestmentLimit - currentTotalInvestment;
        return {
          'success': false, 
          'message': 'Investment limit exceeded. Available amount: ₹${availableAmount.toStringAsFixed(2)}'
        };
      }
      
      // Check if stock already exists
      final existingIndex = holdings.indexWhere((h) => h['symbol'] == stock['symbol']);
      
      if (existingIndex >= 0) {
        // Check if adding more shares would exceed limit
        final existing = holdings[existingIndex];
        final newShares = existing['shares'] + stock['shares'];
        final newInvestmentAmount = newShares * stock['avgPrice'];
        final newTotalInvestment = currentTotalInvestment - (existing['shares'] * existing['avgPrice']) + newInvestmentAmount;
        
        if (newTotalInvestment > _maxInvestmentLimit) {
          final maxAdditionalShares = ((_maxInvestmentLimit - currentTotalInvestment + (existing['shares'] * existing['avgPrice'])) / stock['avgPrice']).floor();
          return {
            'success': false, 
            'message': 'Cannot add ${stock['shares']} shares. Maximum additional shares: $maxAdditionalShares'
          };
        }
        
        // Update existing holding
        final newAvgPrice = ((existing['avgPrice'] * existing['shares']) + 
                           (stock['avgPrice'] * stock['shares'])) / newShares;
        
        holdings[existingIndex] = {
          ...existing,
          'shares': newShares,
          'avgPrice': newAvgPrice,
          'currentPrice': stock['currentPrice'],
          'totalValue': newShares * stock['currentPrice'],
          'gain': (stock['currentPrice'] - newAvgPrice) * newShares,
          'gainPercent': ((stock['currentPrice'] - newAvgPrice) / newAvgPrice) * 100,
          'isPositive': stock['currentPrice'] >= newAvgPrice,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
      } else {
        // Add new holding
        final gain = (stock['currentPrice'] - stock['avgPrice']) * stock['shares'];
        final gainPercent = ((stock['currentPrice'] - stock['avgPrice']) / stock['avgPrice']) * 100;
        
        holdings.add({
          ...stock,
          'totalValue': stock['shares'] * stock['currentPrice'],
          'gain': gain,
          'gainPercent': gainPercent,
          'isPositive': stock['currentPrice'] >= stock['avgPrice'],
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }

      portfolio['holdings'] = holdings;
      portfolio['totalValue'] = _calculateTotalValue(holdings);
      portfolio['totalGain'] = _calculateTotalGain(holdings);
      portfolio['gainPercentage'] = _calculateGainPercentage(portfolio['totalValue'], portfolio['totalGain']);
      portfolio['totalInvestment'] = _calculateTotalInvestment(holdings);
      portfolio['availableCash'] = _maxInvestmentLimit - portfolio['totalInvestment'];
      portfolio['lastUpdated'] = DateTime.now().toIso8601String();
      
      await updateUserPortfolio(portfolio);
      
      return {
        'success': true, 
        'message': 'Successfully added ${stock['shares']} shares of ${stock['symbol']}',
        'portfolio': portfolio
      };
    } catch (e) {
      print('Error adding stock: $e');
      return {'success': false, 'message': 'Failed to add stock to portfolio'};
    }
  }

  // Remove stock from portfolio
  static Future<Map<String, dynamic>> removeStockFromPortfolio(String symbol, int shares) async {
    if (_userId.isEmpty) return {'success': false, 'message': 'User not authenticated'};

    try {
      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      
      final existingIndex = holdings.indexWhere((h) => h['symbol'] == symbol);
      if (existingIndex < 0) {
        return {'success': false, 'message': 'Stock not found in portfolio'};
      }
      
      final existing = holdings[existingIndex];
      if (existing['shares'] < shares) {
        return {'success': false, 'message': 'Insufficient shares. Available: ${existing['shares']}'};
      }
      
      final remainingShares = existing['shares'] - shares;
      
      if (remainingShares <= 0) {
        // Remove entire holding
        holdings.removeAt(existingIndex);
      } else {
        // Update holding with remaining shares
        holdings[existingIndex] = {
          ...existing,
          'shares': remainingShares,
          'totalValue': remainingShares * existing['currentPrice'],
          'gain': (existing['currentPrice'] - existing['avgPrice']) * remainingShares,
          'gainPercent': ((existing['currentPrice'] - existing['avgPrice']) / existing['avgPrice']) * 100,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
      }

      portfolio['holdings'] = holdings;
      portfolio['totalValue'] = _calculateTotalValue(holdings);
      portfolio['totalGain'] = _calculateTotalGain(holdings);
      portfolio['gainPercentage'] = _calculateGainPercentage(portfolio['totalValue'], portfolio['totalGain']);
      portfolio['totalInvestment'] = _calculateTotalInvestment(holdings);
      portfolio['availableCash'] = _maxInvestmentLimit - portfolio['totalInvestment'];
      portfolio['lastUpdated'] = DateTime.now().toIso8601String();
      
      await updateUserPortfolio(portfolio);
      
      return {
        'success': true, 
        'message': 'Successfully sold $shares shares of $symbol',
        'portfolio': portfolio
      };
    } catch (e) {
      print('Error removing stock: $e');
      return {'success': false, 'message': 'Failed to remove stock from portfolio'};
    }
  }

  // Update stock prices in portfolio and calculate daily P&L
  static Future<void> updatePortfolioPrices(List<Map<String, dynamic>> stockPrices) async {
    if (_userId.isEmpty) return;

    try {
      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      double dailyPnL = 0.0;
      
      for (int i = 0; i < holdings.length; i++) {
        final holding = holdings[i];
        final stockPrice = stockPrices.firstWhere(
          (sp) => sp['symbol'] == holding['symbol'],
          orElse: () => {'price': holding['currentPrice']},
        );
        
        final currentPrice = stockPrice['price'];
        final previousPrice = holding['currentPrice'] ?? holding['avgPrice'];
        final shares = holding['shares'];
        final avgPrice = holding['avgPrice'];
        
        // Calculate daily P&L for this holding
        final holdingDailyPnL = (currentPrice - previousPrice) * shares;
        dailyPnL += holdingDailyPnL;
        
        holdings[i] = {
          ...holding,
          'currentPrice': currentPrice,
          'totalValue': shares * currentPrice,
          'gain': (currentPrice - avgPrice) * shares,
          'gainPercent': ((currentPrice - avgPrice) / avgPrice) * 100,
          'isPositive': currentPrice >= avgPrice,
          'dailyPnL': holdingDailyPnL,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
      }

      portfolio['holdings'] = holdings;
      portfolio['totalValue'] = _calculateTotalValue(holdings);
      portfolio['totalGain'] = _calculateTotalGain(holdings);
      portfolio['gainPercentage'] = _calculateGainPercentage(portfolio['totalValue'], portfolio['totalGain']);
      portfolio['totalInvestment'] = _calculateTotalInvestment(holdings);
      portfolio['availableCash'] = _maxInvestmentLimit - portfolio['totalInvestment'];
      portfolio['dailyPnL'] = dailyPnL;
      portfolio['lastUpdated'] = DateTime.now().toIso8601String();
      
      await updateUserPortfolio(portfolio);
    } catch (e) {
      print('Error updating prices: $e');
      throw Exception('Failed to update portfolio prices');
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    if (_userId.isEmpty) return _getDefaultProfile();

    try {
      final doc = await _firestore.collection('users').doc(_userId).get();
      if (doc.exists) {
        return doc.data() ?? _getDefaultProfile();
      } else {
        final user = _auth.currentUser;
        final defaultProfile = _getDefaultProfile();
        if (user != null) {
          defaultProfile['name'] = user.displayName ?? 'User';
          defaultProfile['email'] = user.email ?? '';
          defaultProfile['photoUrl'] = user.photoURL ?? '';
        }
        await _firestore.collection('users').doc(_userId).set(defaultProfile);
        return defaultProfile;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return _getDefaultProfile();
    }
  }

  // Update user profile
  static Future<void> updateUserProfile(Map<String, dynamic> profile) async {
    if (_userId.isEmpty) return;

    try {
      await _firestore.collection('users').doc(_userId).set(profile);
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile');
    }
  }

  // Helper methods
  static Map<String, dynamic> _getDefaultPortfolio() {
    return {
      'totalValue': 10000.0,
      'totalGain': 0.0,
      'gainPercentage': 0.0,
      'totalInvestment': 0.0,
      'availableCash': _maxInvestmentLimit,
      'dailyPnL': 0.0,
      'holdings': [],
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> _getDefaultProfile() {
    return {
      'name': 'User',
      'email': '',
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static Map<String, dynamic> _validatePortfolioData(Map<String, dynamic> data) {
    return {
      'totalValue': (data['totalValue'] ?? 0.0).toDouble(),
      'totalGain': (data['totalGain'] ?? 0.0).toDouble(),
      'gainPercentage': (data['gainPercentage'] ?? 0.0).toDouble(),
      'totalInvestment': (data['totalInvestment'] ?? 0.0).toDouble(),
      'availableCash': (data['availableCash'] ?? _maxInvestmentLimit).toDouble(),
      'dailyPnL': (data['dailyPnL'] ?? 0.0).toDouble(),
      'holdings': List<Map<String, dynamic>>.from(data['holdings'] ?? []),
      'lastUpdated': data['lastUpdated'] ?? DateTime.now().toIso8601String(),
    };
  }

  static bool _validateStockData(Map<String, dynamic> stock) {
    return stock['symbol'] != null &&
           stock['name'] != null &&
           stock['shares'] != null &&
           stock['avgPrice'] != null &&
           stock['currentPrice'] != null &&
           stock['shares'] > 0 &&
           stock['avgPrice'] > 0 &&
           stock['currentPrice'] > 0;
  }

  static double _calculateTotalValue(List<Map<String, dynamic>> holdings) {
    return holdings.fold(0.0, (sum, holding) => 
      sum + ((holding['totalValue'] ?? 0.0) as double));
  }

  static double _calculateTotalGain(List<Map<String, dynamic>> holdings) {
    return holdings.fold(0.0, (sum, holding) => 
      sum + ((holding['gain'] ?? 0.0) as double));
  }

  static double _calculateTotalInvestment(List<Map<String, dynamic>> holdings) {
    return holdings.fold(0.0, (sum, holding) => 
      sum + ((holding['shares'] ?? 0) * (holding['avgPrice'] ?? 0.0)));
  }

  static double _calculateGainPercentage(double totalValue, double totalGain) {
    if (totalValue <= 0) return 0.0;
    final investedAmount = totalValue - totalGain;
    if (investedAmount <= 0) return 0.0;
    return (totalGain / investedAmount) * 100;
  }

  // Save user preferences locally
  static Future<void> saveUserPreference(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      }
    } catch (e) {
      print('Error saving preference: $e');
    }
  }

  // Get user preference
  static Future<dynamic> getUserPreference(String key, {dynamic defaultValue}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.get(key) ?? defaultValue;
    } catch (e) {
      print('Error getting preference: $e');
      return defaultValue;
    }
  }

  // Clear user portfolio (for testing/reset)
  static Future<void> clearPortfolio() async {
    if (_userId.isEmpty) return;

    try {
      await _firestore.collection('portfolios').doc(_userId).delete();
    } catch (e) {
      print('Error clearing portfolio: $e');
    }
  }

  // Get portfolio statistics
  static Future<Map<String, dynamic>> getPortfolioStats() async {
    try {
      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      
      if (holdings.isEmpty) {
        return {
          'totalStocks': 0,
          'topPerformer': null,
          'worstPerformer': null,
          'avgGain': 0.0,
          'totalInvestment': 0.0,
          'availableCash': _maxInvestmentLimit,
          'dailyPnL': 0.0,
        };
      }

      // Sort holdings by gain percentage
      holdings.sort((a, b) => (b['gainPercent'] ?? 0.0).compareTo(a['gainPercent'] ?? 0.0));
      
      final topPerformer = holdings.first;
      final worstPerformer = holdings.last;
      final avgGain = holdings.fold(0.0, (sum, h) => sum + (h['gainPercent'] ?? 0.0)) / holdings.length;

      return {
        'totalStocks': holdings.length,
        'topPerformer': topPerformer,
        'worstPerformer': worstPerformer,
        'avgGain': avgGain,
        'totalInvestment': portfolio['totalInvestment'] ?? 0.0,
        'availableCash': portfolio['availableCash'] ?? _maxInvestmentLimit,
        'dailyPnL': portfolio['dailyPnL'] ?? 0.0,
      };
    } catch (e) {
      print('Error getting portfolio stats: $e');
      return {
        'totalStocks': 0,
        'topPerformer': null,
        'worstPerformer': null,
        'avgGain': 0.0,
        'totalInvestment': 0.0,
        'availableCash': _maxInvestmentLimit,
        'dailyPnL': 0.0,
      };
    }
  }

  // Get investment limit
  static double getMaxInvestmentLimit() => _maxInvestmentLimit;
}
