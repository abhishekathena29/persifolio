import 'package:flutter/material.dart';
import 'package:persifolio/services/transaction_service.dart';
import 'package:persifolio/services/enhanced_portfolio_service.dart';
import 'package:persifolio/services/alpha_vantage_service.dart';
import 'package:persifolio/models/portfolio_models.dart';

class TradePage extends StatefulWidget {
  final Map<String, dynamic> stock;
  final String tradeType; // 'buy' or 'sell'

  const TradePage({
    super.key,
    required this.stock,
    required this.tradeType,
  });

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final TextEditingController _sharesController = TextEditingController();
  int _shares = 0;
  double _totalAmount = 0.0;
  bool _isLoading = false;
  StockHolding? _currentHolding;
  bool _loadingHolding = true;

  bool get isBuy => widget.tradeType == 'buy';
  Color get tradeColor => isBuy ? Colors.green : Colors.red;
  String get tradeAction => isBuy ? 'Buy' : 'Sell';

  @override
  void initState() {
    super.initState();
    _sharesController.addListener(_updateTotal);
    if (!isBuy) {
      _loadCurrentHolding();
    } else {
      _loadingHolding = false;
    }
  }

  @override
  void dispose() {
    _sharesController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentHolding() async {
    try {
      final holding = await EnhancedPortfolioService.getStockHolding(
          widget.stock['symbol']);
      setState(() {
        _currentHolding = holding?.symbol.isNotEmpty == true ? holding : null;
        _loadingHolding = false;
      });
    } catch (e) {
      setState(() => _loadingHolding = false);
    }
  }

  void _updateTotal() {
    final shares = int.tryParse(_sharesController.text.trim()) ?? 0;
    final maxShares = _currentHolding?.shares ?? 0;

    int validShares = shares;
    if (!isBuy && shares > maxShares) {
      validShares = maxShares;
      _sharesController.text = maxShares.toString();
      _sharesController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sharesController.text.length),
      );
    }

    setState(() {
      _shares = validShares;
      _totalAmount = validShares * (widget.stock['price'] as num).toDouble();
    });
  }

  void _setShares(int shares) {
    _sharesController.text = shares.toString();
  }

  Future<void> _executeTrade() async {
    if (_shares <= 0) {
      _showError('Please enter a valid number of shares');
      return;
    }

    if (!isBuy &&
        (_currentHolding == null || _shares > _currentHolding!.shares)) {
      _showError('Insufficient shares available');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = TradeOrder(
        symbol: widget.stock['symbol'],
        stockName: widget.stock['name'] ??
            AlphaVantageService.getStockName(widget.stock['symbol']),
        type: isBuy ? TransactionType.buy : TransactionType.sell,
        shares: _shares,
        price: (widget.stock['price'] as num).toDouble(),
      );

      final result = isBuy
          ? await TransactionService.executeBuyOrder(order)
          : await TransactionService.executeSellOrder(order);

      setState(() => _isLoading = false);

      if (result.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: tradeColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(
              context, true); // Return true to indicate successful trade
        }
      } else {
        _showError(result.message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Trade failed: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text('$tradeAction ${widget.stock['symbol']}'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: _loadingHolding
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stock Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: tradeColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isBuy ? Icons.add_circle : Icons.remove_circle,
                            color: tradeColor,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.stock['symbol'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.stock['name'] ??
                              AlphaVantageService.getStockName(
                                  widget.stock['symbol']),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Current Price:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '₹${(widget.stock['price'] as num).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Current Holdings (for sell orders)
                  if (!isBuy && _currentHolding != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Holdings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Available Shares:',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '${_currentHolding!.shares}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Average Price:',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '₹${_currentHolding!.avgPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Value:',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '₹${_currentHolding!.totalValue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // No holdings message for sell orders
                  if (!isBuy && _currentHolding == null) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No Holdings Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                            'You don\'t own any shares of this stock',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Shares Input
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Number of Shares',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _sharesController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: !isBuy && _currentHolding != null
                                ? 'Max: ${_currentHolding!.shares}'
                                : 'Enter quantity',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.shopping_cart,
                              color: Color(0xFFFF6B35),
                            ),
                            suffixText: !isBuy && _currentHolding != null
                                ? '/${_currentHolding!.shares}'
                                : null,
                            suffixStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF6B35),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),

                        // Quick selection buttons for sell orders
                        if (!isBuy && _currentHolding != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickButton(
                                  '25%',
                                  (_currentHolding!.shares * 0.25).round(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildQuickButton(
                                  '50%',
                                  (_currentHolding!.shares * 0.5).round(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildQuickButton(
                                  '75%',
                                  (_currentHolding!.shares * 0.75).round(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildQuickButton(
                                  'Max',
                                  _currentHolding!.shares,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Total Amount
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          tradeColor.withOpacity(0.2),
                          tradeColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: tradeColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹${_totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: tradeColor,
                              ),
                            ),
                          ],
                        ),
                        if (_shares > 0) ...[
                          const SizedBox(height: 8),
                          Text(
                            '$_shares × ₹${(widget.stock['price'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Execute Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ||
                              _shares <= 0 ||
                              (!isBuy && _currentHolding == null)
                          ? null
                          : _executeTrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _shares > 0 &&
                                (!isBuy ? _currentHolding != null : true)
                            ? tradeColor
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              '$tradeAction ${_shares > 0 ? '$_shares Shares' : 'Stock'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickButton(String label, int value) {
    return GestureDetector(
      onTap: () => _setShares(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B35).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFF6B35),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
