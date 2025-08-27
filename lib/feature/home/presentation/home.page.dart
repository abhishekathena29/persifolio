import 'package:flutter/material.dart';
import 'package:persifolio/feature/simulation/pages/simulation_home.dart';
import 'package:persifolio/feature/home/model/stock_portfolio_model.dart';

class HomePage extends StatefulWidget {
  final String portfolioScoreName;
  const HomePage({super.key, required this.portfolioScoreName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  Map<String, dynamic> portfolioData = {};
  List<Map<String, dynamic>> sectors = [];
  double totalValue = 100000;
  List<Color> pieColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFF9800),
    const Color(0xFF9C27B0),
    const Color(0xFFF44336),
    const Color(0xFF00BCD4),
    const Color(0xFF795548),
    const Color(0xFF607D8B),
  ];

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
    
    _loadPortfolioData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadPortfolioData() {
    // Load portfolio data based on score
    switch (widget.portfolioScoreName) {
      case "Income with Capital Preservation":
        portfolioData = {
          'name': 'Income with Capital Preservation',
          // 25/25/25/25 split from screenshot
          'sectors': [
            {
              'name': 'Cash',
              'percentage': 25.0,
              'where': ['Fixed deposits']
            },
            {
              'name': 'Commodities',
              'percentage': 25.0,
              'where': ['Gold', 'Platinum', 'Crude oil']
            },
            {
              'name': 'Long term bonds',
              'percentage': 25.0,
              'where': ['Government bonds', 'Corporate bonds', 'High Yield bonds']
            },
            {
              'name': 'Equity/Stocks',
              'percentage': 25.0,
              'where': ['Blue chip stocks', 'Developed markets', 'Nifty index stocks']
            },
          ]
        };
        break;
      case "Income with Moderate Growth":
        portfolioData = {
          'name': 'Income with Moderate Growth',
          // Dividends portfolio 25/25/50
          'sectors': [
            {
              'name': 'Cash',
              'percentage': 25.0,
              'where': ['Fixed deposits']
            },
            {
              'name': 'Long term bonds',
              'percentage': 25.0,
              'where': ['Government bonds', 'Corporate bonds', 'High Yield bonds']
            },
            {
              'name': 'Equity/Stocks (Dividends)',
              'percentage': 50.0,
              'where': ['Blue chip stocks', 'Developed markets', 'Nifty index stocks']
            },
          ]
        };
        break;
      case "Growth with Income":
        portfolioData = {
          'name': 'Growth with Income',
          // 8/8/42/42 split
          'sectors': [
            {'name': 'Cash', 'percentage': 8.0, 'where': ['Fixed deposits']},
            {
              'name': 'Commodities',
              'percentage': 8.0,
              'where': ['Gold', 'Platinum', 'Crude oil']
            },
            {
              'name': 'Long term bonds',
              'percentage': 42.0,
              'where': ['Government bonds', 'Corporate bonds', 'High Yield bonds']
            },
            {
              'name': 'Equity/Stocks',
              'percentage': 42.0,
              'where': ['Blue chip stocks', 'Developed markets', 'Nifty index stocks', 'Mid cap stocks']
            },
          ]
        };
        break;
      case "Growth":
        portfolioData = {
          'name': 'Growth',
          // 8/8/14/70 split
          'sectors': [
            {'name': 'Cash', 'percentage': 8.0, 'where': ['Fixed deposits']},
            {
              'name': 'Commodities',
              'percentage': 8.0,
              'where': ['Gold', 'Platinum', 'Crude oil']
            },
            {
              'name': 'Long term bonds',
              'percentage': 14.0,
              'where': ['Government bonds', 'Corporate bonds', 'High Yield bonds']
            },
            {
              'name': 'Equity/Stocks',
              'percentage': 70.0,
              'where': ['Stocks with strong fundamentals', 'Developing markets', 'Nifty index stocks', 'Mid cap stocks']
            },
          ]
        };
        break;
      case "Aggressive Growth":
        portfolioData = {
          'name': 'Aggressive Growth',
          // 3/10/7/60/20 split (Angel funding extra)
          'sectors': [
            {'name': 'Cash', 'percentage': 3.0, 'where': ['Fixed deposits']},
            {'name': 'Commodities', 'percentage': 10.0, 'where': ['Gold', 'Platinum', 'Crude oil']},
            {'name': 'Long term bonds', 'percentage': 7.0, 'where': ['Government bonds', 'Corporate bonds', 'High Yield bonds']},
            {'name': 'Equity/Stocks', 'percentage': 60.0, 'where': ['Small cap stocks', 'Developing markets', 'Nifty index stocks', 'Mid cap stocks', 'IPOs']},
            {'name': 'Angel funding', 'percentage': 20.0, 'where': ['Startups']},
          ]
        };
        break;
      default:
        portfolioData = {
          'name': 'Growth with Income',
          'sectors': [
            {'name': 'Cash', 'percentage': 8.0, 'where': ['Fixed deposits']},
            {'name': 'Commodities', 'percentage': 8.0, 'where': ['Gold', 'Platinum', 'Crude oil']},
            {'name': 'Long term bonds', 'percentage': 42.0, 'where': ['Government bonds', 'Corporate bonds', 'High Yield bonds']},
            {'name': 'Equity/Stocks', 'percentage': 42.0, 'where': ['Blue chip stocks', 'Developed markets', 'Nifty index stocks']},
          ]
        };
    }

    sectors = List<Map<String, dynamic>>.from(portfolioData['sectors'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          'Portfolio: ${widget.portfolioScoreName}',
          style: const TextStyle(
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
              icon: const Icon(Icons.attach_money, color: Color(0xFF4CAF50)),
              onPressed: () {
                _showAmountDialog();
              },
            ),
          ),
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
              icon: const Icon(Icons.trending_up, color: Color(0xFF4CAF50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimulationHomePage()),
                );
              },
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portfolio Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A1A),
                        Color(0xFF2A2A2A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Portfolio Value',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ASSIGNED',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '₹${totalValue.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Pie Chart Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.pie_chart,
                              color: Color(0xFF4CAF50),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Portfolio Allocation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Donut Pie Chart
                      SizedBox(
                        height: 220,
                        child: CustomPaint(
                          painter: DonutChartPainter(
                            sectors: sectors,
                            colors: pieColors,
                            backgroundColor: const Color(0xFF0F0F0F),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Allocation',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  '${sectors.fold<double>(0, (p, e) => p + (e['percentage'] as num).toDouble()).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Legend
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          for (int i = 0; i < sectors.length; i++)
                            _legendItem(
                              color: pieColors[i % pieColors.length],
                              label:
                                  "${sectors[i]['name']} ${sectors[i]['percentage']}%",
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Simulator Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SimulationHomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Go to Simulator',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Allocation Breakdown
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
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
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.show_chart,
                              color: Color(0xFF4CAF50),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Allocation Breakdown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sectors.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final sector = sectors[index];
                          final color = pieColors[index % pieColors.length];
                          final percent = (sector['percentage'] as num).toDouble();
                          final amount = totalValue * percent / 100.0;
                          final List whereList = List.from(sector['where'] ?? []);
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F0F0F),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade800),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.circle, color: color, size: 16),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sector['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          for (final item in whereList)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1A1A1A),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.grey.shade800),
                                              ),
                                              child: Text(
                                                item.toString(),
                                                style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${percent.toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '₹${amount.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAmountDialog() {
    final controller = TextEditingController(text: totalValue.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Enter Investment Amount',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Amount in INR',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            prefixIcon: const Icon(Icons.currency_rupee, color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text.replaceAll(',', ''));
              if (parsed != null && parsed > 0) {
                setState(() {
                  totalValue = parsed;
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.grey.shade300, fontSize: 12)),
      ],
    );
  }
}

class DonutChartPainter extends CustomPainter {
  DonutChartPainter({
    required this.sectors,
    required this.colors,
    this.backgroundColor = const Color(0xFF0F0F0F),
  });

  final List<Map<String, dynamic>> sectors;
  final List<Color> colors;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide / 2) - 8;
    final strokeWidth = radius * 0.35;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    double startAngle = -90 * 3.1415926535 / 180; // start at top
    final totalPercent = sectors.fold<double>(0, (p, e) => p + (e['percentage'] as num).toDouble());

    for (int i = 0; i < sectors.length; i++) {
      final percent = (sectors[i]['percentage'] as num).toDouble();
      if (percent <= 0) continue;
      final sweep = (percent / totalPercent) * 2 * 3.1415926535;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
