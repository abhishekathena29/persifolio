import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persifolio/feature/home/model/stock_portfolio_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.portfolioScoreName});
  final String portfolioScoreName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;

  List<Color> pieColor = const [
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
  ];

  final amountController = TextEditingController();
  int? amount;

  @override
  Widget build(BuildContext context) {
    // String portfolioName = "";
    // List<StockPortfolioModel> portfolio = [
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Cash',
    //     diversification: 3.0,
    //     where: 'Fixed deposits',
    //     companyName: 'Kotak mahindra bank',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Commodities',
    //     diversification: 10.0 / 3,
    //     where: 'Gold',
    //     companyName: 'Gold',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Commodities',
    //     diversification: 10.0 / 3,
    //     where: 'Platinum',
    //     companyName: 'Platinum',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Commodities',
    //     diversification: 10.0 / 3,
    //     where: 'Crude oil',
    //     companyName: 'Crude oil',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Long term bonds',
    //     diversification: 7.0 / 3,
    //     where: 'Government bonds',
    //     companyName: 'Bharat bond',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Long term bonds',
    //     diversification: 7.0 / 3,
    //     where: 'Corporate bonds',
    //     companyName: 'TCFS bond',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Long term bonds',
    //     diversification: 7.0 / 3,
    //     where: 'High Yield bonds',
    //     companyName: 'TFCS bond',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty/blue chip',
    //     companyName: 'TCS',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty/blue chip',
    //     companyName: 'INFY',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty/blue chip',
    //     companyName: 'WIPRO',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty/blue chip',
    //     companyName: 'COAL INDIA',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty/blue chip',
    //     companyName: 'SBI',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Developed markets',
    //     companyName: 'Airtel',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Developed markets',
    //     companyName: 'Bio con',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Developed markets',
    //     companyName: 'TATA STEEL',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty Midcap stocks',
    //     companyName: 'Yes bank',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty Midcap stocks',
    //     companyName: 'Tata Comm',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty Midcap stocks',
    //     companyName: 'Ashok Leyland',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Nifty Midcap stocks',
    //     companyName: 'LnT finance',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Small cap stocks',
    //     companyName: 'KIOCL ltd',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Small cap stocks',
    //     companyName: 'One 97',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'Small cap stocks',
    //     companyName: 'Castrol india',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'IPOs',
    //     companyName: 'OLA electric',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Equity/Stocks',
    //     diversification: 70.0 / 18,
    //     where: 'IPOs',
    //     companyName: 'Hyundai motors',
    //     addedDate: now,
    //   ),
    //   StockPortfolioModel(
    //     portfolioName: portfolioName,
    //     sectorSplit: 'Angel funding',
    //     diversification: 10.0,
    //     where: 'Startups',
    //     companyName: 'Angel list venture https://www.angellist.com/',
    //     addedDate: now,
    //   ),
    // ];

    String b = "Aggressive Growth";
    // String c = "Income with Capital Preservation";
    // String d = "Income with Moderate Growth";
    // String e = "Growth with Income";
    // String f = "Growth";

    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   // for (var a in portfolio)
      //   //   FirebaseFirestore.instance.collection('portfolios').add(a.toMap());
      //   var a = await FirebaseFirestore.instance
      //       .collection('portfolios')
      //       .where('companyName', isEqualTo: 'TCFS bond')
      //       .get();
      //   for (var e in a.docs) {
      //     FirebaseFirestore.instance.collection('portfolios').doc(e.id).update({
      //       'companyAbout':
      //           "Tata Capital Financial Services (TCFS) bonds are fixed-income instruments issued by one of India's leading financial service providers. These bonds offer investors a stable income stream with attractive interest rates, backed by the strong financial standing of the Tata Group. TCFS bonds are ideal for conservative investors seeking regular returns with relatively low risk. The company’s diversified lending portfolio and prudent risk management enhance the security of these bonds. They are suitable for those looking for a reliable fixed-income investment within India's corporate bond market."
      //     });
      //   }
      // }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Personalised Stock Portfolio",
          // style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recommended Portfolio Name'),
                        Text(
                          widget.portfolioScoreName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 30, bottom: 20, right: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Type the value to invest',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 15),
                                      TextField(
                                        controller: amountController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: 'Value'),
                                      ),
                                      const SizedBox(height: 15),
                                      ElevatedButton(
                                        onPressed: () {
                                          amount =
                                              int.parse(amountController.text);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                      // showDialog(context: context, builder: (context)=>Material(child: ,))
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) => Container(
                      //     child: Column(
                      //       children: [
                      //         Text('Type the value to invest'),
                      //         TextField(
                      //           keyboardType: TextInputType.number,
                      //           decoration: InputDecoration(hintText: 'Value'),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('portfolios')
                      .where('portfolioName',
                          isEqualTo: widget.portfolioScoreName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var list = snapshot.data!.docs
                          .map((snap) =>
                              StockPortfolioModel.fromMap(snap.data()))
                          .toList();
                      var sectorList =
                          list.map((e) => e.sectorSplit).toSet().toList();
                      List<double> diversList = [];
                      Map<String, double> mp = Map.fromIterables(
                          list.map((e) => e.sectorSplit).toSet(),
                          List.filled(sectorList.length, 0));
                      for (var l in list) {
                        mp[l.sectorSplit] =
                            mp[l.sectorSplit]! + l.diversification;
                      }

                      mp.forEach((k, v) => diversList.add(v));

                      List<PieChartSectionData> showingSections() {
                        return List.generate(sectorList.length, (i) {
                          final isTouched = i == touchedIndex;
                          final fontSize = isTouched ? 25.0 : 16.0;
                          final radius = isTouched ? 120.0 : 100.0;
                          const shadows = [
                            Shadow(color: Colors.black, blurRadius: 2)
                          ];
                          return PieChartSectionData(
                            color: pieColor[i],
                            value: diversList[i],
                            title: diversList[i].toStringAsFixed(1),
                            radius: radius,
                            titleStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: shadows,
                            ),
                          );
                        });
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PieChart(PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 20,
                              sections: showingSections(),
                            )),
                          ),
                          const SizedBox(height: 50),
                          ListView.separated(
                            itemCount: sectorList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var b = list
                                  .where((element) =>
                                      element.sectorSplit == sectorList[index])
                                  .toList();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    sectorList[index],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  ...List.generate(
                                      b.length,
                                      (j) => GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 25,
                                                        ),
                                                        child: Text(
                                                          b[j].companyAbout,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        ),
                                                      ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color:
                                                        Colors.green.shade100),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      b[j].companyName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "${b[j].diversification.toStringAsPrecision(4)}%"),
                                                    if (amount != null)
                                                      Text(
                                                          '₹${((amount! * b[j].diversification) / 100).toStringAsFixed(2)}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(40)),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     ElevatedButton(onPressed: () {}, child: const Icon(Icons.send))
              //   ],
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
