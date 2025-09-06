import 'package:flutter/material.dart';
import 'package:persifolio/services/alpha_vantage_service.dart';
import 'package:persifolio/services/portfolio_service.dart';
import 'package:persifolio/feature/simulation/pages/stock_detail.dart';

class SimulationHomePage extends StatefulWidget {
  const SimulationHomePage({super.key});

  @override
  State<SimulationHomePage> createState() => _SimulationHomePageState();
}

class _SimulationHomePageState extends State<SimulationHomePage>
    with TickerProviderStateMixin {
  double _portfolioValue = 10000.0;
  double _totalGain = 0.0;
  double _gainPercentage = 0.0;
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _topStocks = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _loadInitialData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      // Set default profile for demo
      _userProfile = {
        'name': 'Investor',
        'email': 'demo@example.com',
        'photoUrl': '',
      };

      // Load portfolio data
      await _loadPortfolioData();

      // Use static/local data for initial display - no API calls
      _topStocks = _getStaticStockData();

      setState(() {
        _isLoading = false;
      });

      // Start animations
      _animationController.forward();
    } catch (e) {
      print('Error in _loadInitialData: $e');
      setState(() => _isLoading = false);
    }
  }

  // Static stock data for initial display
  List<Map<String, dynamic>> _getStaticStockData() {
    return [
      {
        'symbol': 'RELIANCE.BSE',
        'name': 'Reliance Industries Ltd',
        'price': 2456.78,
        'change': 45.67,
        'changePercent': 1.89,
        'isPositive': true,
        'previousClose': 2411.11,
        'open': 2420.00,
        'high': 2470.00,
        'low': 2400.00,
      },
      {
        'symbol': 'TCS.BSE',
        'name': 'Tata Consultancy Services Ltd',
        'price': 3890.45,
        'change': -23.45,
        'changePercent': -0.60,
        'isPositive': false,
        'previousClose': 3913.90,
        'open': 3920.00,
        'high': 3950.00,
        'low': 3870.00,
      },
      {
        'symbol': 'HDFCBANK.BSE',
        'name': 'HDFC Bank Ltd',
        'price': 1678.90,
        'change': 34.56,
        'changePercent': 2.10,
        'isPositive': true,
        'previousClose': 1644.34,
        'open': 1650.00,
        'high': 1690.00,
        'low': 1640.00,
      },
      {
        'symbol': 'INFY.BSE',
        'name': 'Infosys Ltd',
        'price': 1456.78,
        'change': 12.34,
        'changePercent': 0.85,
        'isPositive': true,
        'previousClose': 1444.44,
        'open': 1450.00,
        'high': 1470.00,
        'low': 1440.00,
      },
      {
        'symbol': 'ICICIBANK.BSE',
        'name': 'ICICI Bank Ltd',
        'price': 987.65,
        'change': -15.43,
        'changePercent': -1.54,
        'isPositive': false,
        'previousClose': 1003.08,
        'open': 1005.00,
        'high': 1010.00,
        'low': 980.00,
      },
      {
        'symbol': 'WIPRO.BSE',
        'name': 'Wipro Ltd',
        'price': 456.78,
        'change': 8.92,
        'changePercent': 1.99,
        'isPositive': true,
        'previousClose': 447.86,
        'open': 450.00,
        'high': 460.00,
        'low': 445.00,
      },
      {
        'symbol': 'HINDUNILVR.BSE',
        'name': 'Hindustan Unilever Ltd',
        'price': 2634.50,
        'change': 28.75,
        'changePercent': 1.10,
        'isPositive': true,
        'previousClose': 2605.75,
        'open': 2610.00,
        'high': 2645.00,
        'low': 2600.00,
      },
      {
        'symbol': 'ITC.BSE',
        'name': 'ITC Ltd',
        'price': 456.30,
        'change': -5.20,
        'changePercent': -1.13,
        'isPositive': false,
        'previousClose': 461.50,
        'open': 460.00,
        'high': 465.00,
        'low': 452.00,
      },
      {
        'symbol': 'SBIN.BSE',
        'name': 'State Bank of India',
        'price': 623.45,
        'change': 18.90,
        'changePercent': 3.13,
        'isPositive': true,
        'previousClose': 604.55,
        'open': 608.00,
        'high': 630.00,
        'low': 605.00,
      },
      {
        'symbol': 'BHARTIARTL.BSE',
        'name': 'Bharti Airtel Ltd',
        'price': 1234.60,
        'change': -12.40,
        'changePercent': -0.99,
        'isPositive': false,
        'previousClose': 1247.00,
        'open': 1245.00,
        'high': 1250.00,
        'low': 1230.00,
      },
    ];
  }

  Future<void> _loadPortfolioData() async {
    try {
      final portfolio = await PortfolioService.getUserPortfolio();
      setState(() {
        _portfolioValue = (portfolio['totalValue'] ?? 10000.0).toDouble();
        _totalGain = (portfolio['totalGain'] ?? 1250.0).toDouble();
        _gainPercentage = (portfolio['gainPercentage'] ?? 12.5).toDouble();
      });
    } catch (e) {
      print('Error loading portfolio: $e');
      // Keep default values
    }
  }

  // Method for explicit refresh - this will make API calls
  Future<void> _refreshStockData() async {
    try {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Load fresh data from API when user explicitly refreshes
      final stocks = await AlphaVantageService.getTopBSEStocks();
      setState(() {
        _topStocks = stocks;
        _isLoading = false;
      });

      // Also refresh portfolio data
      await _loadPortfolioData();
    } catch (e) {
      print('Error refreshing stocks: $e');
      setState(() {
        _isLoading = false;
      });

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('rate limit')
                  ? 'API rate limit exceeded. Please try again later.'
                  : 'Failed to refresh data. Please try again.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading simulation data...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Header with Portfolio Value
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total portfolio',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${_portfolioValue.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      const Icon(
                                        Icons.flash_on,
                                        color: Color(0xFFFF6B35),
                                        size: 24,
                                      ),
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFF6B35),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Text(
                                            '3',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Performance Chart
                            Container(
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(7, (index) {
                                  final height = 20.0 + (index % 3) * 15.0;
                                  final isPositive = index % 2 == 0;
                                  return Container(
                                    width: 8,
                                    height: height,
                                    decoration: BoxDecoration(
                                      color: isPositive
                                          ? Colors.green
                                          : Colors.grey.shade600,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('16',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                Text('23',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                Text('30',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Top Performing Asset
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amazon',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'TOP PERFORMING',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFFF6B35),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '+14%',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Category Performance
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.flash_on,
                                          color: Color(0xFFFF6B35),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Energy',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '+67%',
                                      style: TextStyle(
                                        color: Color(0xFFFF6B35),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.67,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B35),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.memory,
                                          color: Color(0xFFFF6B35),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Technology',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '+25%',
                                      style: TextStyle(
                                        color: Color(0xFFFF6B35),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B35),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Market Overview Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Market Overview',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final selected =
                                      await showSearch<Map<String, dynamic>?>(
                                    context: context,
                                    delegate: _StockSearchDelegate(),
                                  );
                                  if (selected != null && mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StockDetailPage(stock: selected),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.search,
                                    color: Color(0xFFFF6B35)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Stock List
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshStockData,
                          color: const Color(0xFFFF6B35),
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
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  (stock['symbol'] as String).isNotEmpty
                      ? stock['symbol'][0]
                      : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
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
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    stock['name'] ??
                        AlphaVantageService.getStockName(stock['symbol']),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stock['isPositive']
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        stock['isPositive']
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: stock['isPositive'] ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${stock['isPositive'] ? '+' : ''}${(stock['changePercent'] as num).toStringAsFixed(2)}%',
                        style: TextStyle(
                          color:
                              stock['isPositive'] ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Type to search NSE/BSE stocks',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _results[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                (item['symbol'] as String).isNotEmpty ? item['symbol'][0] : '?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),
          ),
          title: Text(item['symbol']),
          subtitle: Text(item['name'] ?? ''),
          trailing: Text(item['currency'] ?? ''),
          onTap: () async {
            try {
              final quote =
                  await AlphaVantageService.getStockQuote(item['symbol']);
              final stock = {
                ...quote,
                'name': item['name'] ??
                    AlphaVantageService.getStockName(item['symbol']),
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
