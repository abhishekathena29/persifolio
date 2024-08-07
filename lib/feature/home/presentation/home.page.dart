import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persifolio/feature/home/model/stock_portfolio_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.portfolioScoreName});
  final String portfolioScoreName;

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

    // String b = "Aggressive Growth";
    // String c = "Income with Capital Preservation";
    // String d = "Income with Moderate Growth";
    // String e = "Growth with Income";
    // String f = "Growth";

    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   for (var a in portfolio)
      //     FirebaseFirestore.instance.collection('portfolios').add(a.toMap());
      //   var a = await FirebaseFirestore.instance
      //       .collection('portfolios')
      //       .where('portfolioName',
      //           isEqualTo: 'Investment with Moderate Growth')
      //       .get();
      //   for (var e in a.docs) {
      //     FirebaseFirestore.instance
      //         .collection('portfolios')
      //         .doc(e.id)
      //         .update({'portfolioName': "Income with Moderate Growth"});
      //   }
      // }),
      appBar: AppBar(
        title: const Text(
          "Personalised Stock Portfolio",
          // style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommended Portfolio Name'),
            Text(
              portfolioScoreName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('portfolios')
                      .where('portfolioName', isEqualTo: portfolioScoreName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var list = snapshot.data!.docs
                          .map((snap) =>
                              StockPortfolioModel.fromMap(snap.data()))
                          .toList();
                      var sectorList =
                          list.map((e) => e.sectorSplit).toSet().toList();
                      return ListView.separated(
                          itemCount: sectorList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
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
                                      (j) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.green.shade100),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    b[j].companyName,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "${b[j].diversification.toStringAsPrecision(4)}%"),
                                                ],
                                              ),
                                            ),
                                          )),
                                ]);
                          });
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
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
    );
  }
}
