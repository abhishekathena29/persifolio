import 'package:flutter/material.dart';
import 'package:persifolio/feature/simulation/pages/simulation_home.dart';
import 'package:persifolio/services/firebase_portfolio_service.dart';
import 'package:persifolio/models/firebase_portfolio_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

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
  List<FirebasePortfolio> portfolioCompanies = [];
  bool isLoadingPortfolio = false;
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
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
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

  void _loadPortfolioData() async {
    if (mounted) {
      setState(() {
        isLoadingPortfolio = true;
      });
    }

    try {
      // First try to get portfolio companies from Firebase
      final companies =
          await FirebasePortfolioService.getUserAssignedPortfolioCompanies();

      if (companies.isNotEmpty) {
        portfolioCompanies = companies;

        // Group companies by sector split
        final groupedCompanies =
            FirebasePortfolioService.groupCompaniesBySector(companies);
        final portfolioSectors =
            FirebasePortfolioService.convertToPortfolioSectors(
                groupedCompanies);

        portfolioData = {
          'name': companies.first.portfolioName,
          'sectors': portfolioSectors
              .map((sector) => {
                    'name': sector.name,
                    'percentage': sector.percentage,
                    'where': sector.instruments,
                    'description': sector.description,
                    'companies': sector.companies,
                  })
              .toList(),
        };
        sectors =
            List<Map<String, dynamic>>.from(portfolioData['sectors'] ?? []);
      } else {
        // Fallback to hardcoded data if Firebase data is not available
        // _loadFallbackPortfolioData();
      }
    } catch (e) {
      print('Error loading portfolio from Firebase: $e');
      // // Fallback to hardcoded data
      // _loadFallbackPortfolioData();
    }
    if (mounted) {
      setState(() {
        isLoadingPortfolio = false;
      });
    }
  }

  // void _loadFallbackPortfolioData() {
  //   // Load portfolio data based on score (fallback)
  //   switch (widget.portfolioScoreName) {
  //     case "Income with Capital Preservation":
  //       portfolioData = {
  //         'name': 'Income with Capital Preservation',
  //         'sectors': [
  //           {
  //             'name': 'Cash',
  //             'percentage': 25.0,
  //             'where': ['Fixed deposits']
  //           },
  //           {
  //             'name': 'Commodities',
  //             'percentage': 25.0,
  //             'where': ['Gold', 'Platinum', 'Crude oil']
  //           },
  //           {
  //             'name': 'Long term bonds',
  //             'percentage': 25.0,
  //             'where': [
  //               'Government bonds',
  //               'Corporate bonds',
  //               'High Yield bonds'
  //             ]
  //           },
  //           {
  //             'name': 'Equity/Stocks',
  //             'percentage': 25.0,
  //             'where': [
  //               'Blue chip stocks',
  //               'Developed markets',
  //               'Nifty index stocks'
  //             ]
  //           },
  //         ]
  //       };
  //       break;
  //     case "Income with Moderate Growth":
  //       portfolioData = {
  //         'name': 'Income with Moderate Growth',
  //         'sectors': [
  //           {
  //             'name': 'Cash',
  //             'percentage': 25.0,
  //             'where': ['Fixed deposits']
  //           },
  //           {
  //             'name': 'Long term bonds',
  //             'percentage': 25.0,
  //             'where': [
  //               'Government bonds',
  //               'Corporate bonds',
  //               'High Yield bonds'
  //             ]
  //           },
  //           {
  //             'name': 'Equity/Stocks (Dividends)',
  //             'percentage': 50.0,
  //             'where': [
  //               'Blue chip stocks',
  //               'Developed markets',
  //               'Nifty index stocks'
  //             ]
  //           },
  //         ]
  //       };
  //       break;
  //     case "Growth with Income":
  //       portfolioData = {
  //         'name': 'Growth with Income',
  //         'sectors': [
  //           {
  //             'name': 'Cash',
  //             'percentage': 8.0,
  //             'where': ['Fixed deposits']
  //           },
  //           {
  //             'name': 'Commodities',
  //             'percentage': 8.0,
  //             'where': ['Gold', 'Platinum', 'Crude oil']
  //           },
  //           {
  //             'name': 'Long term bonds',
  //             'percentage': 42.0,
  //             'where': [
  //               'Government bonds',
  //               'Corporate bonds',
  //               'High Yield bonds'
  //             ]
  //           },
  //           {
  //             'name': 'Equity/Stocks',
  //             'percentage': 42.0,
  //             'where': [
  //               'Blue chip stocks',
  //               'Developed markets',
  //               'Nifty index stocks',
  //               'Mid cap stocks'
  //             ]
  //           },
  //         ]
  //       };
  //       break;
  //     case "Growth":
  //       portfolioData = {
  //         'name': 'Growth',
  //         'sectors': [
  //           {
  //             'name': 'Cash',
  //             'percentage': 8.0,
  //             'where': ['Fixed deposits']
  //           },
  //           {
  //             'name': 'Commodities',
  //             'percentage': 8.0,
  //             'where': ['Gold', 'Platinum', 'Crude oil']
  //           },
  //           {
  //             'name': 'Long term bonds',
  //             'percentage': 14.0,
  //             'where': [
  //               'Government bonds',
  //               'Corporate bonds',
  //               'High Yield bonds'
  //             ]
  //           },
  //           {
  //             'name': 'Equity/Stocks',
  //             'percentage': 70.0,
  //             'where': [
  //               'Stocks with strong fundamentals',
  //               'Developing markets',
  //               'Nifty index stocks',
  //               'Mid cap stocks'
  //             ]
  //           },
  //         ]
  //       };
  //       break;
  //     case "Aggressive Growth":
  //       portfolioData = {
  //         'name': 'Aggressive Growth',
  //         'sectors': [
  //           {
  //             'name': 'Cash',
  //             'percentage': 3.0,
  //             'where': ['Fixed deposits']
  //           },
  //           {
  //             'name': 'Commodities',
  //             'percentage': 10.0,
  //             'where': ['Gold', 'Platinum', 'Crude oil']
  //           },
  //           {
  //             'name': 'Long term bonds',
  //             'percentage': 7.0,
  //             'where': [
  //               'Government bonds',
  //               'Corporate bonds',
  //               'High Yield bonds'
  //             ]
  //           },
  //           {
  //             'name': 'Equity/Stocks',
  //             'percentage': 60.0,
  //             'where': [
  //               'Small cap stocks',
  //               'Developing markets',
  //               'Nifty index stocks',
  //               'Mid cap stocks',
  //               'IPOs'
  //             ]
  //           },
  //           {
  //             'name': 'Angel funding',
  //             'percentage': 20.0,
  //             'where': ['Startups']
  //           },
  //         ]
  //       };
  //       break;
  //     default:
  //       portfolioData = {
  //         'name': 'Growth with Income',
  //         'sectors': [
  //           {
  //             'name': 'Cash',
  //             'percentage': 8.0,
  //             'where': ['Fixed deposits']
  //           },
  //           {
  //             'name': 'Commodities',
  //             'percentage': 8.0,
  //             'where': ['Gold', 'Platinum', 'Crude oil']
  //           },
  //           {
  //             'name': 'Long term bonds',
  //             'percentage': 42.0,
  //             'where': [
  //               'Government bonds',
  //               'Corporate bonds',
  //               'High Yield bonds'
  //             ]
  //           },
  //           {
  //             'name': 'Equity/Stocks',
  //             'percentage': 42.0,
  //             'where': [
  //               'Blue chip stocks',
  //               'Developed markets',
  //               'Nifty index stocks'
  //             ]
  //           },
  //         ]
  //       };
  //   }

  //   sectors = List<Map<String, dynamic>>.from(portfolioData['sectors'] ?? []);
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Portfolio',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.15),
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
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: isLoadingPortfolio
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading your portfolio...',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Portfolio Summary Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDarkMode
                                ? [
                                    const Color(0xFF1A1A1A),
                                    const Color(0xFF2A2A2A),
                                  ]
                                : [
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.05),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.15),
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
                                Text(
                                  'Portfolio Value',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'ASSIGNED',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
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
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Portfolio Companies Summary (if available from Firebase)
                      if (portfolioCompanies.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color:
                                    const Color(0xFF4CAF50).withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4CAF50).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.business,
                                  color: Color(0xFF4CAF50),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Portfolio: ${portfolioCompanies.first.portfolioName}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${portfolioCompanies.length} companies across ${sectors.length} sectors',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Pie Chart Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.15),
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
                                    color: const Color(0xFF4CAF50)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.pie_chart,
                                    color: Color(0xFF4CAF50),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Portfolio Allocation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
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
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Allocation',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        '${sectors.fold<double>(0, (p, e) => p + (e['percentage'] as num).toDouble()).toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SimulationHomePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
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
                                child: Icon(
                                  Icons.trending_up,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
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
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.15),
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
                                    color: const Color(0xFF4CAF50)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.show_chart,
                                    color: Color(0xFF4CAF50),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Allocation Breakdown',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sectors.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final sector = sectors[index];
                                final color =
                                    pieColors[index % pieColors.length];
                                final percent =
                                    (sector['percentage'] as num).toDouble();
                                final amount = totalValue * percent / 100.0;
                                final List whereList =
                                    List.from(sector['where'] ?? []);
                                final List<FirebasePortfolio> companies =
                                    List<FirebasePortfolio>.from(
                                        sector['companies'] ?? []);
                                return _buildSectorCard(
                                  context: context,
                                  isDarkMode: isDarkMode,
                                  color: color,
                                  name: sector['name'],
                                  percent: percent,
                                  amount: amount,
                                  whereList: whereList,
                                  companies: companies,
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
    final controller =
        TextEditingController(text: totalValue.toStringAsFixed(0));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Enter Investment Amount',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: 'Amount in INR',
            hintStyle:
                TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            prefixIcon: Icon(Icons.currency_rupee,
                color: Theme.of(context).textTheme.bodySmall?.color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color)),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed =
                  double.tryParse(controller.text.replaceAll(',', ''));
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorCard({
    required BuildContext context,
    required bool isDarkMode,
    required Color color,
    required String name,
    required double percent,
    required double amount,
    required List whereList,
    required List<FirebasePortfolio> companies,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: color dot + sector name + percentage pill
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Visual allocation bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),

          // Invested amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Invested Amount',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),

          // Holdings / instruments section
          if (companies.isNotEmpty || whereList.isNotEmpty) ...[
            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
            const SizedBox(height: 14),
            Text(
              companies.isNotEmpty ? 'HOLDINGS' : 'INSTRUMENTS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 10),
            if (companies.isNotEmpty)
              Column(
                children: [
                  for (final company in companies)
                    _buildCompanyTile(context, isDarkMode, color, company),
                ],
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in whereList)
                    _buildInstrumentChip(
                        context, isDarkMode, item.toString()),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompanyTile(BuildContext context, bool isDarkMode, Color color,
      FirebasePortfolio company) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  company.companyName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${company.diversification.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            company.where,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
            ),
          ),
          if (company.about.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              company.about,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstrumentChip(
      BuildContext context, bool isDarkMode, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color,
          fontSize: 12,
        ),
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
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12)),
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
    final totalPercent = sectors.fold<double>(
        0, (p, e) => p + (e['percentage'] as num).toDouble());

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
