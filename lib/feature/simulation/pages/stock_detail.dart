import 'package:flutter/material.dart';
import 'package:persifolio/services/alpha_vantage_service.dart';
import 'package:persifolio/services/portfolio_service.dart';

class StockDetailPage extends StatefulWidget {
  final Map<String, dynamic> stock;
  
  const StockDetailPage({super.key, required this.stock});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  int _selectedTimeframe = 0;
  final List<String> _timeframes = ['1D', '1W', '1M', '3M', '1Y', 'ALL'];
  bool _loadingChart = true;
  List<Map<String, dynamic>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _loadChart();
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.stock['symbol'],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.stock['name'],
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Price Section
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${widget.stock['price'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              widget.stock['isPositive'] ? Icons.trending_up : Icons.trending_down,
                              color: widget.stock['isPositive'] ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.stock['isPositive'] ? '+' : ''}\$${widget.stock['change'].toStringAsFixed(2)} (${widget.stock['isPositive'] ? '+' : ''}${widget.stock['changePercent'].toStringAsFixed(2)}%)',
                              style: TextStyle(
                                color: widget.stock['isPositive'] ? Colors.green : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'NSE/BSE',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Timeframe Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _timeframes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final timeframe = entry.value;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTimeframe = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedTimeframe == index
                              ? const Color(0xFF6366F1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          timeframe,
                          style: TextStyle(
                            color: _selectedTimeframe == index
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Simple chart placeholder with ticks using loaded data
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
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
            child: _loadingChart
                ? const Center(child: CircularProgressIndicator())
                : (_chartData.isEmpty
                    ? const Center(child: Text('No intraday data'))
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            _chartData.length,
                            (i) => Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 2,
                                  height: 5 + (i % 7) * 3,
                                  color: const Color(0xFF6366F1).withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
          ),

          const SizedBox(height: 20),

          // Stock Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stock Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Market', 'NSE/BSE'),
                _buildInfoRow('Prev Close', '₹${(widget.stock['previousClose'] as num?)?.toStringAsFixed(2) ?? '-'}'),
                _buildInfoRow('Open', '₹${(widget.stock['open'] as num?)?.toStringAsFixed(2) ?? '-'}'),
                _buildInfoRow('High', '₹${(widget.stock['high'] as num?)?.toStringAsFixed(2) ?? '-'}'),
                _buildInfoRow('Low', '₹${(widget.stock['low'] as num?)?.toStringAsFixed(2) ?? '-'}'),
                _buildInfoRow('P/E Ratio', '28.5'),
                _buildInfoRow('Dividend Yield', '0.5%'),
                _buildInfoRow('52 Week High', '—'),
                _buildInfoRow('52 Week Low', '—'),
              ],
            ),
          ),

          const Spacer(),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showBuyDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Buy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showSellDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sell',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy ${widget.stock['symbol']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Price: ₹${(widget.stock['price'] as num).toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const _SharesField(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final shares = _SharesField.of(context)?.shares ?? 0;
              if (shares <= 0) return;
              final stock = {
                'symbol': widget.stock['symbol'],
                'name': widget.stock['name'],
                'shares': shares,
                'avgPrice': (widget.stock['price'] as num).toDouble(),
                'currentPrice': (widget.stock['price'] as num).toDouble(),
              };
              await PortfolioService.addStockToPortfolio(stock);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sell ${widget.stock['symbol']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Price: ₹${(widget.stock['price'] as num).toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const _SharesField(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final shares = _SharesField.of(context)?.shares ?? 0;
              if (shares <= 0) return;
              await PortfolioService.removeStockFromPortfolio(
                widget.stock['symbol'],
                shares,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }
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
      decoration: const InputDecoration(
        labelText: 'Number of Shares',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}