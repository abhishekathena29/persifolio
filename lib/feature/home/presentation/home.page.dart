import 'package:flutter/material.dart';
import 'package:persifolio/feature/home/model/stock_portfolio_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final StockPortfolioModel test = StockPortfolioModel(
    portfolioName: "Portfolio 1",
    stocks: [
      Stocks(commpanyName: "HDFC", percentage: 0.5),
      Stocks(commpanyName: "Reliance", percentage: 0.1),
      Stocks(commpanyName: "ICICI", percentage: 0.2),
      Stocks(commpanyName: "ADANI", percentage: 0.1),
      Stocks(commpanyName: "TATA", percentage: 0.1),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personalised Stock Portfolio",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const Text(
              "Portfolio #1",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: test.stocks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff38A07D)
                        .withOpacity(test.stocks[index].percentage),
                  ),
                  child: Column(
                    children: [
                      Text(
                        test.stocks[index].commpanyName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        (test.stocks[index].percentage * 100).toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "2000",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Icon(Icons.send))
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
