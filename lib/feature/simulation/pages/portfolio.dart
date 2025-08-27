import 'package:flutter/material.dart';
import 'package:persifolio/services/portfolio_service.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with TickerProviderStateMixin {
  double _totalValue = 0.0;
  double _totalGain = 0.0;
  double _gainPercentage = 0.0;
  bool _loading = true;
  List<Map<String, dynamic>> _holdings = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _loadPortfolio();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPortfolio() async {
    setState(() => _loading = true);
    try {
      final data = await PortfolioService.getUserPortfolio();
      setState(() {
        _totalValue = (data['totalValue'] ?? 0.0).toDouble();
        _totalGain = (data['totalGain'] ?? 0.0).toDouble();
        _gainPercentage = (data['gainPercentage'] ?? 0.0).toDouble();
        _holdings = List<Map<String, dynamic>>.from(data['holdings'] ?? []);
        _loading = false;
      });
      _animationController.forward();
    } catch (e) {
      print('Error loading portfolio: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'My Portfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFFFF6B35)),
              onPressed: _loadPortfolio,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading portfolio...',
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
                child: RefreshIndicator(
                  onRefresh: _loadPortfolio,
                  color: const Color(0xFFFF6B35),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Portfolio Summary Card
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Portfolio Value',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${_totalValue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _totalGain >= 0 
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _totalGain >= 0 ? Icons.trending_up : Icons.trending_down,
                                          color: _totalGain >= 0 ? Colors.green : Colors.red,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${_totalGain >= 0 ? '+' : ''}₹${_totalGain.abs().toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: _totalGain >= 0 ? Colors.green : Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${_gainPercentage.toStringAsFixed(1)}%)',
                                    style: TextStyle(
                                      color: _totalGain >= 0 ? Colors.green : Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Holdings Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Holdings',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${_holdings.length} stocks',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Holdings List
                        if (_holdings.isEmpty)
                          Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No holdings yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start building your portfolio by buying stocks',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _holdings.length,
                            itemBuilder: (context, index) {
                              final holding = _holdings[index];
                              return _buildHoldingCard(holding);
                            },
                          ),

                        const SizedBox(height: 20),

                        // Portfolio Performance
                        if (_holdings.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(20),
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
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6B35).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.analytics,
                                        color: Color(0xFFFF6B35),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Portfolio Performance',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildPerformanceRow('Total Invested', '₹${(_totalValue - _totalGain).toStringAsFixed(2)}', Icons.account_balance_wallet),
                                _buildPerformanceRow('Current Value', '₹${_totalValue.toStringAsFixed(2)}', Icons.trending_up),
                                _buildPerformanceRow('Total Gain/Loss', '${_totalGain >= 0 ? '+' : ''}₹${_totalGain.toStringAsFixed(2)}', 
                                    _totalGain >= 0 ? Icons.trending_up : Icons.trending_down,
                                    color: _totalGain >= 0 ? Colors.green : Colors.red),
                                _buildPerformanceRow('Gain Percentage', '${_gainPercentage.toStringAsFixed(1)}%', Icons.percent,
                                    color: _gainPercentage >= 0 ? Colors.green : Colors.red),
                              ],
                            ),
                          ),

                        const SizedBox(height: 100), // Space for bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHoldingCard(Map<String, dynamic> holding) {
    final currentValue = (holding['shares'] as int) * (holding['currentPrice'] as double);
    final avgValue = (holding['shares'] as int) * (holding['avgPrice'] as double);
    final gain = currentValue - avgValue;
    final gainPercentage = avgValue > 0 ? (gain / avgValue) * 100 : 0;

    return Container(
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
      child: Column(
        children: [
          Row(
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
                    (holding['symbol'] as String).isNotEmpty ? holding['symbol'][0] : '?',
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
                      holding['symbol'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      holding['name'] ?? '',
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
                    '₹${currentValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: gain >= 0 
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          gain >= 0 ? Icons.trending_up : Icons.trending_down,
                          color: gain >= 0 ? Colors.green : Colors.red,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${gain >= 0 ? '+' : ''}${gainPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: gain >= 0 ? Colors.green : Colors.red,
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHoldingDetail('Shares', '${holding['shares']}'),
              _buildHoldingDetail('Avg Price', '₹${(holding['avgPrice'] as double).toStringAsFixed(2)}'),
              _buildHoldingDetail('Current', '₹${(holding['currentPrice'] as double).toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? const Color(0xFFFF6B35),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
          );
  }
}