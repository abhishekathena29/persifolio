import 'package:flutter/material.dart';
import 'package:persifolio/services/alpha_vantage_service.dart';
import 'package:persifolio/services/portfolio_service.dart';
import 'dart:math' as math;

class StockDetailPage extends StatefulWidget {
  final Map<String, dynamic> stock;
  
  const StockDetailPage({super.key, required this.stock});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> with TickerProviderStateMixin {
  int _selectedTimeframe = 0;
  final List<String> _timeframes = ['1D', '1W', '1M', '3M', '1Y', 'ALL'];
  bool _loadingChart = true;
  List<Map<String, dynamic>> _chartData = [];
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
    _loadChart();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadChart() async {
    setState(() => _loadingChart = true);
    try {
      final data = await AlphaVantageService.getStockIntraday(widget.stock['symbol']);
      setState(() {
        _chartData = List<Map<String, dynamic>>.from(data['chartData'] ?? []);
        _loadingChart = false;
      });
    } catch (e) {
      setState(() => _loadingChart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
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
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stock['symbol'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.stock['name'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 70, bottom: 16),
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
                  icon: const Icon(Icons.favorite_border, color: Color(0xFFFF6B35)),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Price Section
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Current Price',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹${widget.stock['price'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'NSE/BSE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.stock['isPositive'] 
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      widget.stock['isPositive'] ? Icons.trending_up : Icons.trending_down,
                                      color: widget.stock['isPositive'] ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.stock['isPositive'] ? '+' : ''}₹${widget.stock['change'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: widget.stock['isPositive'] ? Colors.green : Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${widget.stock['isPositive'] ? '+' : ''}${widget.stock['changePercent'].toStringAsFixed(2)}%)',
                                style: TextStyle(
                                  color: widget.stock['isPositive'] ? Colors.green : Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Timeframe Selector
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _timeframes.asMap().entries.map((entry) {
                          final index = entry.key;
                          final timeframe = entry.value;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTimeframe = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedTimeframe == index
                                    ? const Color(0xFFFF6B35)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                timeframe,
                                style: TextStyle(
                                  color: _selectedTimeframe == index
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Enhanced Chart
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 250,
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
                      child: _loadingChart
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading chart data...',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : (_chartData.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.show_chart,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No chart data available',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Price Chart',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: _buildEnhancedChart(),
                                      ),
                                    ],
                                  ),
                                )),
                    ),

                    const SizedBox(height: 20),

                    // Stock Information
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(24),
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
                                  Icons.info_outline,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Stock Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow('Market', 'NSE/BSE', Icons.business),
                          _buildInfoRow('Previous Close', '₹${(widget.stock['previousClose'] as num?)?.toStringAsFixed(2) ?? '-'}', Icons.trending_down),
                          _buildInfoRow('Open', '₹${(widget.stock['open'] as num?)?.toStringAsFixed(2) ?? '-'}', Icons.trending_up),
                          _buildInfoRow('High', '₹${(widget.stock['high'] as num?)?.toStringAsFixed(2) ?? '-'}', Icons.keyboard_arrow_up),
                          _buildInfoRow('Low', '₹${(widget.stock['low'] as num?)?.toStringAsFixed(2) ?? '-'}', Icons.keyboard_arrow_down),
                          _buildInfoRow('P/E Ratio', '28.5', Icons.analytics),
                          _buildInfoRow('Dividend Yield', '0.5%', Icons.account_balance),
                          _buildInfoRow('52 Week High', '₹2,850.00', Icons.trending_up),
                          _buildInfoRow('52 Week Low', '₹1,200.00', Icons.trending_down),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for bottom buttons
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showBuyDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Buy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSellDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sell',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedChart() {
    if (_chartData.isEmpty) return const SizedBox();
    
    final maxValue = _chartData.fold<double>(0, (max, item) => 
      math.max(max, (item['close'] as num?)?.toDouble() ?? 0));
    final minValue = _chartData.fold<double>(double.infinity, (min, item) => 
      math.min(min, (item['close'] as num?)?.toDouble() ?? double.infinity));
    final range = maxValue - minValue;
    
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: ChartPainter(
        data: _chartData,
        maxValue: maxValue,
        minValue: minValue,
        range: range,
        isPositive: widget.stock['isPositive'],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFFFF6B35),
            ),
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildTradeDialog(context, 'Buy', Colors.green),
    );
  }

  void _showSellDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildTradeDialog(context, 'Sell', Colors.red),
    );
  }

  Widget _buildTradeDialog(BuildContext context, String action, Color color) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                action == 'Buy' ? Icons.add : Icons.remove,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$action ${widget.stock['symbol']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Price: ₹${(widget.stock['price'] as num).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const _SharesField(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final shares = _SharesField.of(context)?.shares ?? 0;
                      if (shares <= 0) return;
                      
                      if (action == 'Buy') {
                        final stock = {
                          'symbol': widget.stock['symbol'],
                          'name': widget.stock['name'],
                          'shares': shares,
                          'avgPrice': (widget.stock['price'] as num).toDouble(),
                          'currentPrice': (widget.stock['price'] as num).toDouble(),
                        };
                        await PortfolioService.addStockToPortfolio(stock);
                      } else {
                        await PortfolioService.removeStockFromPortfolio(
                          widget.stock['symbol'],
                          shares,
                        );
                      }
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully $action ${shares} shares of ${widget.stock['symbol']}'),
                            backgroundColor: color,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      action,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class ChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final double minValue;
  final double range;
  final bool isPositive;

  ChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    required this.range,
    required this.isPositive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = (isPositive ? Colors.green : Colors.red).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final width = size.width;
    final height = size.height;
    final stepX = width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final value = (item['close'] as num?)?.toDouble() ?? 0;
      final x = i * stepX;
      final y = height - ((value - minValue) / range * height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(width, height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SharesField extends StatefulWidget {
  const _SharesField();

  static _SharesFieldState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SharesFieldState>();

  @override
  State<_SharesField> createState() => _SharesFieldState();
}

class _SharesFieldState extends State<_SharesField> {
  final TextEditingController _controller = TextEditingController();
  int shares = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        shares = int.tryParse(_controller.text.trim()) ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Number of Shares',
        hintText: 'Enter quantity',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
        ),
        prefixIcon: const Icon(Icons.shopping_cart, color: Color(0xFFFF6B35)),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
    );
  }
}