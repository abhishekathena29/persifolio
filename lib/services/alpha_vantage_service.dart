import 'dart:convert';
import 'package:http/http.dart' as http;

class AlphaVantageService {
  static const String _apiKey = 'VW82C6YRO1S60RQI';
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  // Popular NSE stocks
  static const List<String> _nseStocks = [
    'RELIANCE.NSE', 'TCS.NSE', 'HDFCBANK.NSE', 'INFY.NSE', 'ICICIBANK.NSE',
    'HINDUNILVR.NSE', 'ITC.NSE', 'SBIN.NSE', 'BHARTIARTL.NSE', 'KOTAKBANK.NSE',
    'AXISBANK.NSE', 'ASIANPAINT.NSE', 'MARUTI.NSE', 'HCLTECH.NSE', 'SUNPHARMA.NSE',
    'WIPRO.NSE', 'ULTRACEMCO.NSE', 'TITAN.NSE', 'BAJFINANCE.NSE', 'NESTLEIND.NSE'
  ];

  static Future<Map<String, dynamic>> getStockQuote(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Global Quote'] != null) {
          final quote = data['Global Quote'];
          return {
            'symbol': quote['01. symbol'] ?? symbol,
            'price': double.tryParse(quote['05. price'] ?? '0') ?? 0.0,
            'change': double.tryParse(quote['09. change'] ?? '0') ?? 0.0,
            'changePercent': double.tryParse(quote['10. change percent']?.replaceAll('%', '') ?? '0') ?? 0.0,
            'volume': int.tryParse(quote['06. volume'] ?? '0') ?? 0,
            'previousClose': double.tryParse(quote['08. previous close'] ?? '0') ?? 0.0,
            'open': double.tryParse(quote['02. open'] ?? '0') ?? 0.0,
            'high': double.tryParse(quote['03. high'] ?? '0') ?? 0.0,
            'low': double.tryParse(quote['04. low'] ?? '0') ?? 0.0,
            'isPositive': (double.tryParse(quote['09. change'] ?? '0') ?? 0.0) >= 0,
          };
        }
      }
      throw Exception('Failed to load stock data');
    } catch (e) {
      throw Exception('Error fetching stock data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getTopNSEStocks() async {
    List<Map<String, dynamic>> stocks = [];
    
    for (String symbol in _nseStocks.take(10)) {
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
        Uri.parse('$_baseUrl?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$_apiKey'),
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

  static Future<List<Map<String, dynamic>>> searchSymbols(String keywords) async {
    if (keywords.trim().isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?function=SYMBOL_SEARCH&keywords=$keywords&apikey=$_apiKey'),
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

          final isIndia = region.toLowerCase().contains('india') || currency.toUpperCase() == 'INR';
          final isNseOrBse = symbol.endsWith('.BSE') || symbol.endsWith('.NSE');
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
      'RELIANCE.NSE': 'Reliance Industries Ltd',
      'TCS.NSE': 'Tata Consultancy Services Ltd',
      'HDFCBANK.NSE': 'HDFC Bank Ltd',
      'INFY.NSE': 'Infosys Ltd',
      'ICICIBANK.NSE': 'ICICI Bank Ltd',
      'HINDUNILVR.NSE': 'Hindustan Unilever Ltd',
      'ITC.NSE': 'ITC Ltd',
      'SBIN.NSE': 'State Bank of India',
      'BHARTIARTL.NSE': 'Bharti Airtel Ltd',
      'KOTAKBANK.NSE': 'Kotak Mahindra Bank Ltd',
      'AXISBANK.NSE': 'Axis Bank Ltd',
      'ASIANPAINT.NSE': 'Asian Paints Ltd',
      'MARUTI.NSE': 'Maruti Suzuki India Ltd',
      'HCLTECH.NSE': 'HCL Technologies Ltd',
      'SUNPHARMA.NSE': 'Sun Pharmaceutical Industries Ltd',
      'WIPRO.NSE': 'Wipro Ltd',
      'ULTRACEMCO.NSE': 'UltraTech Cement Ltd',
      'TITAN.NSE': 'Titan Company Ltd',
      'BAJFINANCE.NSE': 'Bajaj Finance Ltd',
      'NESTLEIND.NSE': 'Nestle India Ltd',
    };

    return names[symbol] ?? symbol.replaceAll('.NSE', '');
  }
}
