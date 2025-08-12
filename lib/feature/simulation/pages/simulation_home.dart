import 'package:flutter/material.dart';
import 'package:persifolio/feature/simulation/pages/portfolio.dart';
import 'package:persifolio/feature/simulation/pages/stock_detail.dart';
import 'package:persifolio/services/alpha_vantage_service.dart';
import 'package:persifolio/services/portfolio_service.dart';

class SimulationHomePage extends StatefulWidget {
  const SimulationHomePage({super.key});

  @override
  State<SimulationHomePage> createState() => _SimulationHomePageState();
}

class _SimulationHomePageState extends State<SimulationHomePage> {
  double _portfolioValue = 10000.0;
  double _totalGain = 0.0;
  double _gainPercentage = 0.0;
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _topStocks = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final profile = await PortfolioService.getUserProfile();
      final portfolio = await PortfolioService.getUserPortfolio();
      final stocks = await AlphaVantageService.getTopNSEStocks();

      setState(() {
        _userProfile = profile;
        _portfolioValue = (portfolio['totalValue'] ?? 10000.0).toDouble();
        _totalGain = (portfolio['totalGain'] ?? 0.0).toDouble();
        _gainPercentage = (portfolio['gainPercentage'] ?? 0.0).toDouble();
        _topStocks = stocks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          (_userProfile?['name'] as String?) ?? 'Investor',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final selected = await showSearch<Map<String, dynamic>?>(
                        context: context,
                        delegate: _StockSearchDelegate(),
                      );
                      if (selected != null) {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockDetailPage(stock: selected),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            
            // Portfolio Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Portfolio Value',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${_portfolioValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        _totalGain >= 0 ? Icons.trending_up : Icons.trending_down,
                        color: _totalGain >= 0 ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_totalGain >= 0 ? '+' : '-'}₹${_totalGain.abs().toStringAsFixed(2)} (${_gainPercentage.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          color: _totalGain >= 0 ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.add,
                      title: 'Buy',
                      color: Colors.green,
                      onTap: () => _showBuyDialog(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.remove,
                      title: 'Sell',
                      color: Colors.red,
                      onTap: () => _showSellDialog(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.analytics,
                      title: 'Portfolio',
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PortfolioPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Market Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Market Overview (NSE/BSE)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selected = await showSearch<Map<String, dynamic>?>(
                        context: context,
                        delegate: _StockSearchDelegate(),
                      );
                      if (selected != null) {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockDetailPage(stock: selected),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Stock List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadInitialData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _topStocks.length,
                        itemBuilder: (context, index) {
                          final stock = _topStocks[index];
                          return _buildStockCard(stock);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockDetailPage(stock: stock),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  (stock['symbol'] as String).isNotEmpty ? stock['symbol'][0] : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock['symbol'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stock['name'] ?? AlphaVantageService.getStockName(stock['symbol']),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${(stock['price'] as num).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      stock['isPositive'] ? Icons.trending_up : Icons.trending_down,
                      color: stock['isPositive'] ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${stock['isPositive'] ? '+' : ''}${(stock['changePercent'] as num).toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: stock['isPositive'] ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy Stock'),
        content: const Text('Open a stock to buy from its detail page.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Stock'),
        content: const Text('Open a stock to sell from its detail page.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final photo = _userProfile?['photoUrl'] as String?;
    if (photo != null && photo.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(photo),
      );
    }
    return const CircleAvatar(
      radius: 20,
      backgroundColor: Color(0xFF6366F1),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

class _StockSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  @override
  String get searchFieldLabel => 'Search NSE/BSE stocks (e.g., RELIANCE, TCS)';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (_isLoading)
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _results = [];
          _isLoading = false;
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _search(query);
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type to search NSE/BSE stocks'));
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _results[index];
        return ListTile(
          title: Text(item['symbol']),
          subtitle: Text(item['name'] ?? ''),
          trailing: Text(item['currency'] ?? ''),
          onTap: () async {
            try {
              final quote = await AlphaVantageService.getStockQuote(item['symbol']);
              final stock = {
                ...quote,
                'name': item['name'] ?? AlphaVantageService.getStockName(item['symbol']),
              };
              if (context.mounted) close(context, stock);
            } catch (_) {
              if (context.mounted) close(context, null);
            }
          },
        );
      },
    );
  }

  Future<void> _search(String q) async {
    if (q.trim().isEmpty) return;
    _isLoading = true;
    try {
      final res = await AlphaVantageService.searchSymbols(q.trim());
      _results = res;
    } catch (_) {
      _results = [];
    } finally {
      _isLoading = false;
    }
  }
}