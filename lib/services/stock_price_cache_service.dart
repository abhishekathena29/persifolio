import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'alpha_vantage_service.dart';

class StockPriceCacheService {
  static const String _cachePrefix = 'stock_price_';
  static const Duration _cacheExpiration = Duration(minutes: 15);

  /// Get stock price from cache or fetch from API
  static Future<Map<String, dynamic>?> getStockPrice(String symbol,
      {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      // Try to get from cache first
      final cached = await _getCachedPrice(symbol);
      if (cached != null) {
        return cached;
      }
    }

    // Fetch from API and cache it
    try {
      final quote = await AlphaVantageService.getStockQuote(symbol);
      await _cachePrice(symbol, quote);
      return quote;
    } catch (e) {
      print('Error fetching stock price for $symbol: $e');
      // Return cached price even if expired as fallback
      return await _getCachedPrice(symbol, ignoreExpiry: true);
    }
  }

  /// Get multiple stock prices efficiently
  static Future<Map<String, Map<String, dynamic>>> getMultipleStockPrices(
      List<String> symbols,
      {bool forceRefresh = false}) async {
    final Map<String, Map<String, dynamic>> prices = {};

    for (final symbol in symbols) {
      final price = await getStockPrice(symbol, forceRefresh: forceRefresh);
      if (price != null) {
        prices[symbol] = price;
        // Add delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }

    return prices;
  }

  /// Cache stock price with timestamp
  static Future<void> _cachePrice(
      String symbol, Map<String, dynamic> priceData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'data': priceData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await prefs.setString('$_cachePrefix$symbol', json.encode(cacheData));
    } catch (e) {
      print('Error caching price for $symbol: $e');
    }
  }

  /// Get cached price if not expired
  static Future<Map<String, dynamic>?> _getCachedPrice(String symbol,
      {bool ignoreExpiry = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString('$_cachePrefix$symbol');

      if (cachedString == null) return null;

      final cacheData = json.decode(cachedString);
      final timestamp = cacheData['timestamp'] as int;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

      // Check if cache is still valid
      if (!ignoreExpiry && cacheAge > _cacheExpiration.inMilliseconds) {
        return null; // Cache expired
      }

      return Map<String, dynamic>.from(cacheData['data']);
    } catch (e) {
      print('Error reading cache for $symbol: $e');
      return null;
    }
  }

  /// Check if cached price exists and is valid
  static Future<bool> hasFreshCache(String symbol) async {
    final cached = await _getCachedPrice(symbol);
    return cached != null;
  }

  /// Clear cache for a specific symbol
  static Future<void> clearCache(String symbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_cachePrefix$symbol');
    } catch (e) {
      print('Error clearing cache for $symbol: $e');
    }
  }

  /// Clear all cached prices
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }

  /// Get cache age in minutes
  static Future<int?> getCacheAge(String symbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString('$_cachePrefix$symbol');

      if (cachedString == null) return null;

      final cacheData = json.decode(cachedString);
      final timestamp = cacheData['timestamp'] as int;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

      return (cacheAge / 60000).floor(); // Convert to minutes
    } catch (e) {
      return null;
    }
  }

  /// Cache static stock data for home page
  static Future<void> cacheStaticStockData(
      List<Map<String, dynamic>> stocks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'data': stocks,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await prefs.setString('static_stocks', json.encode(cacheData));
    } catch (e) {
      print('Error caching static stock data: $e');
    }
  }

  /// Get cached static stock data for home page
  static Future<List<Map<String, dynamic>>?> getCachedStaticStockData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString('static_stocks');

      if (cachedString == null) return null;

      final cacheData = json.decode(cachedString);
      final timestamp = cacheData['timestamp'] as int;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

      // Cache expires after 1 hour for static data
      if (cacheAge > Duration(hours: 1).inMilliseconds) {
        return null;
      }

      return List<Map<String, dynamic>>.from(cacheData['data']);
    } catch (e) {
      print('Error reading static stock cache: $e');
      return null;
    }
  }
}
