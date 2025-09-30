import 'package:flutter/material.dart';
import 'package:persifolio/feature/bottom_navigation/bottom_navigation.dart';
import 'package:persifolio/feature/scoring/score_info_page.dart';

class ScoringPage extends StatelessWidget {
  const ScoringPage({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Colors.white,
        elevation: 0,
        title: const Text(
          'Assessment Complete',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Colors.white,
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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4CAF50)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Score Card
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Color(0xFF4CAF50),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Your Final Score is',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      score.toString(),
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Description
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: const Text(
                  'Explore your portfolio according to the Score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String portfolioType = "";
                    if (score >= 34 && score <= 57) {
                      portfolioType = "Income with Capital Preservation";
                    } else if (score >= 58 && score <= 83) {
                      portfolioType = "Income with Moderate Growth";
                    } else if (score >= 84 && score <= 99) {
                      portfolioType = "Growth with Income";
                    } else if (score >= 100 && score <= 114) {
                      portfolioType = "Growth";
                    } else if (score >= 115 && score <= 125) {
                      portfolioType = "Aggressive Growth";
                    }
                    if (portfolioType.isNotEmpty) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationPage(
                            portfolioScoreName: portfolioType,
                            initialIndex: 0, // Start with Home tab
                          ),
                        ),
                      );
                    }
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
                  child: const Text(
                    'Continue to Portfolio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Info Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InvestorScoreInfoScreen(),
                    ),
                  );
                },
                child: const Text(
                  'How are we calculating the score?',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
