import 'dart:convert';
import 'package:http/http.dart' as http;

class AlphaVantageService {
  static const String _apiKey = 'VW82C6YRO1S60RQI';
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  // Popular BSE stocks (using .BSE suffix for Alpha Vantage API)
  static const List<String> _bseStocks = [
    'RELIANCE.BSE',
    'TCS.BSE',
    'HDFCBANK.BSE',
    'INFY.BSE',
    'ICICIBANK.BSE',
    'HINDUNILVR.BSE',
    'ITC.BSE',
    'SBIN.BSE',
    'BHARTIARTL.BSE',
    'KOTAKBANK.BSE',
    'AXISBANK.BSE',
    'ASIANPAINT.BSE',
    'MARUTI.BSE',
    'HCLTECH.BSE',
    'SUNPHARMA.BSE',
    'WIPRO.BSE',
    'ULTRACEMCO.BSE',
    'TITAN.BSE',
    'BAJFINANCE.BSE',
    'NESTLEIND.BSE'
  ];

  static Future<Map<String, dynamic>> getStockQuote(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check for rate limit message
        if (data['Note'] != null) {
          throw Exception('API rate limit exceeded: ${data['Note']}');
        }

        if (data['Global Quote'] != null) {
          final quote = data['Global Quote'];
          return {
            'symbol': quote['01. symbol'] ?? symbol,
            'price': double.tryParse(quote['05. price'] ?? '0') ?? 0.0,
            'change': double.tryParse(quote['09. change'] ?? '0') ?? 0.0,
            'changePercent': double.tryParse(
                    quote['10. change percent']?.replaceAll('%', '') ?? '0') ??
                0.0,
            'volume': int.tryParse(quote['06. volume'] ?? '0') ?? 0,
            'previousClose':
                double.tryParse(quote['08. previous close'] ?? '0') ?? 0.0,
            'open': double.tryParse(quote['02. open'] ?? '0') ?? 0.0,
            'high': double.tryParse(quote['03. high'] ?? '0') ?? 0.0,
            'low': double.tryParse(quote['04. low'] ?? '0') ?? 0.0,
            'isPositive':
                (double.tryParse(quote['09. change'] ?? '0') ?? 0.0) >= 0,
          };
        }
      }
      throw Exception('Failed to load stock data');
    } catch (e) {
      throw Exception('Error fetching stock data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getTopBSEStocks() async {
    List<Map<String, dynamic>> stocks = [];

    for (String symbol in _bseStocks.take(10)) {
      try {
        final stockData = await getStockQuote(symbol);
        stocks.add({
          ...stockData,
          'name': getStockName(symbol),
        });
        // Add delay to avoid API rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print('Error fetching $symbol: $e');
      }
    }

    return stocks;
  }

  static Future<Map<String, dynamic>> getStockIntraday(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Time Series (5min)'] != null) {
          final timeSeries = data['Time Series (5min)'];
          final entries = timeSeries.entries.toList();

          List<Map<String, dynamic>> chartData = [];
          for (var entry in entries.take(20)) {
            final values = entry.value as Map<String, dynamic>;
            chartData.add({
              'time': entry.key,
              'price': double.tryParse(values['4. close'] ?? '0') ?? 0.0,
            });
          }

          return {
            'symbol': symbol,
            'chartData': chartData.reversed.toList(),
          };
        }
      }
      throw Exception('Failed to load intraday data');
    } catch (e) {
      throw Exception('Error fetching intraday data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> searchSymbols(
      String keywords) async {
    if (keywords.trim().isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?function=SYMBOL_SEARCH&keywords=$keywords&apikey=$_apiKey'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List matches = (data['bestMatches'] ?? []) as List;
        final List<Map<String, dynamic>> results = [];

        for (final raw in matches) {
          final map = Map<String, dynamic>.from(raw);
          final symbol = (map['1. symbol'] as String? ?? '').trim();
          final name = (map['2. name'] as String? ?? '').trim();
          final region = (map['4. region'] as String? ?? '').trim();
          final currency = (map['8. currency'] as String? ?? '').trim();

          final isIndia = region.toLowerCase().contains('india') ||
              currency.toUpperCase() == 'INR';
          final isNseOrBse = symbol.endsWith('.BSE');
          if (!isIndia && !isNseOrBse) continue;

          results.add({
            'symbol': symbol,
            'name': name,
            'region': region,
            'currency': currency,
          });
        }

        return results;
      }
      throw Exception('Failed to search symbols');
    } catch (e) {
      throw Exception('Error searching symbols: $e');
    }
  }

  static String getStockName(String symbol) {
    final names = {
      'RELIANCE.BSE': 'Reliance Industries Ltd',
      'TCS.BSE': 'Tata Consultancy Services Ltd',
      'HDFCBANK.BSE': 'HDFC Bank Ltd',
      'INFY.BSE': 'Infosys Ltd',
      'ICICIBANK.BSE': 'ICICI Bank Ltd',
      'HINDUNILVR.BSE': 'Hindustan Unilever Ltd',
      'ITC.BSE': 'ITC Ltd',
      'SBIN.BSE': 'State Bank of India',
      'BHARTIARTL.BSE': 'Bharti Airtel Ltd',
      'KOTAKBANK.BSE': 'Kotak Mahindra Bank Ltd',
      'AXISBANK.BSE': 'Axis Bank Ltd',
      'ASIANPAINT.BSE': 'Asian Paints Ltd',
      'MARUTI.BSE': 'Maruti Suzuki India Ltd',
      'HCLTECH.BSE': 'HCL Technologies Ltd',
      'SUNPHARMA.BSE': 'Sun Pharmaceutical Industries Ltd',
      'WIPRO.BSE': 'Wipro Ltd',
      'ULTRACEMCO.BSE': 'UltraTech Cement Ltd',
      'TITAN.BSE': 'Titan Company Ltd',
      'BAJFINANCE.BSE': 'Bajaj Finance Ltd',
      'NESTLEIND.BSE': 'Nestle India Ltd',
    };

    return names[symbol] ?? symbol.replaceAll('.BSE', '');
  }
}
