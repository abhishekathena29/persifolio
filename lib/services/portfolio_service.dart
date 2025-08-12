import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get _userId => _auth.currentUser?.uid ?? '';

  // Get user portfolio
  static Future<Map<String, dynamic>> getUserPortfolio() async {
    if (_userId.isEmpty) return _getDefaultPortfolio();

    try {
      final doc = await _firestore.collection('portfolios').doc(_userId).get();
      if (doc.exists) {
        return doc.data() ?? _getDefaultPortfolio();
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
      await _firestore.collection('portfolios').doc(_userId).set(portfolio);
    } catch (e) {
      print('Error updating portfolio: $e');
    }
  }

  // Add stock to portfolio
  static Future<void> addStockToPortfolio(Map<String, dynamic> stock) async {
    if (_userId.isEmpty) return;

    try {
      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      
      // Check if stock already exists
      final existingIndex = holdings.indexWhere((h) => h['symbol'] == stock['symbol']);
      
      if (existingIndex >= 0) {
        // Update existing holding
        final existing = holdings[existingIndex];
        final newShares = existing['shares'] + stock['shares'];
        final newAvgPrice = ((existing['avgPrice'] * existing['shares']) + 
                           (stock['avgPrice'] * stock['shares'])) / newShares;
        
        holdings[existingIndex] = {
          ...existing,
          'shares': newShares,
          'avgPrice': newAvgPrice,
          'totalValue': newShares * stock['currentPrice'],
        };
      } else {
        // Add new holding
        holdings.add({
          ...stock,
          'totalValue': stock['shares'] * stock['currentPrice'],
        });
      }

      portfolio['holdings'] = holdings;
      portfolio['totalValue'] = _calculateTotalValue(holdings);
      portfolio['totalGain'] = _calculateTotalGain(holdings);
      
      await updateUserPortfolio(portfolio);
    } catch (e) {
      print('Error adding stock: $e');
    }
  }

  // Remove stock from portfolio
  static Future<void> removeStockFromPortfolio(String symbol, int shares) async {
    if (_userId.isEmpty) return;

    try {
      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      
      final existingIndex = holdings.indexWhere((h) => h['symbol'] == symbol);
      if (existingIndex >= 0) {
        final existing = holdings[existingIndex];
        final remainingShares = existing['shares'] - shares;
        
        if (remainingShares <= 0) {
          holdings.removeAt(existingIndex);
        } else {
          holdings[existingIndex] = {
            ...existing,
            'shares': remainingShares,
            'totalValue': remainingShares * existing['currentPrice'],
          };
        }
      }

      portfolio['holdings'] = holdings;
      portfolio['totalValue'] = _calculateTotalValue(holdings);
      portfolio['totalGain'] = _calculateTotalGain(holdings);
      
      await updateUserPortfolio(portfolio);
    } catch (e) {
      print('Error removing stock: $e');
    }
  }

  // Update stock prices in portfolio
  static Future<void> updatePortfolioPrices(List<Map<String, dynamic>> stockPrices) async {
    if (_userId.isEmpty) return;

    try {
      final portfolio = await getUserPortfolio();
      final holdings = List<Map<String, dynamic>>.from(portfolio['holdings'] ?? []);
      
      for (int i = 0; i < holdings.length; i++) {
        final holding = holdings[i];
        final stockPrice = stockPrices.firstWhere(
          (sp) => sp['symbol'] == holding['symbol'],
          orElse: () => {'price': holding['currentPrice']},
        );
        
        final currentPrice = stockPrice['price'];
        final shares = holding['shares'];
        final avgPrice = holding['avgPrice'];
        
        holdings[i] = {
          ...holding,
          'currentPrice': currentPrice,
          'totalValue': shares * currentPrice,
          'gain': (currentPrice - avgPrice) * shares,
          'gainPercent': ((currentPrice - avgPrice) / avgPrice) * 100,
          'isPositive': currentPrice >= avgPrice,
        };
      }

      portfolio['holdings'] = holdings;
      portfolio['totalValue'] = _calculateTotalValue(holdings);
      portfolio['totalGain'] = _calculateTotalGain(holdings);
      portfolio['gainPercentage'] = portfolio['totalValue'] > 0 
          ? (portfolio['totalGain'] / (portfolio['totalValue'] - portfolio['totalGain'])) * 100 
          : 0.0;
      
      await updateUserPortfolio(portfolio);
    } catch (e) {
      print('Error updating prices: $e');
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
    }
  }

  // Helper methods
  static Map<String, dynamic> _getDefaultPortfolio() {
    return {
      'totalValue': 10000.0,
      'totalGain': 0.0,
      'gainPercentage': 0.0,
      'holdings': [],
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

  static double _calculateTotalValue(List<Map<String, dynamic>> holdings) {
    return holdings.fold(0.0, (sum, holding) => sum + (holding['totalValue'] ?? 0.0));
  }

  static double _calculateTotalGain(List<Map<String, dynamic>> holdings) {
    return holdings.fold(0.0, (sum, holding) => sum + (holding['gain'] ?? 0.0));
  }

  // Save user preferences locally
  static Future<void> saveUserPreference(String key, dynamic value) async {
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
  }

  // Get user preference
  static Future<dynamic> getUserPreference(String key, {dynamic defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? defaultValue;
  }
}
