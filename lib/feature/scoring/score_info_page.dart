import 'package:flutter/material.dart';

class InvestorScoreInfoScreen extends StatelessWidget {
  const InvestorScoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Investor Scorecard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Questions are divided into three sections-',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time Horizon Total x1 =',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Financial Goals Total x2 =',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Risk Tolerance Total x3 =',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'The total for each section is multiplied by a number that represents the overall importance of that section when determining your investment objectives.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'TOTAL SCORE _______',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Match your total score with one of the investment objectives listed below. If your score is near the top or bottom of an Adjusted Total Range, you may want to examine the next or previous objective to determine which represents your needs more accurately.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Adjusted Total Range - Investment Objective:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '34-57: Income with Capital Preservation',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '58-83: Income with Moderate Growth',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '84-99: Growth with Income',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '100-114: Growth',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '115-125: Aggressive Growth',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
