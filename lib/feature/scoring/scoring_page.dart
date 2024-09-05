import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persifolio/feature/home/presentation/home.page.dart';
import 'package:persifolio/feature/scoring/score_info_page.dart';

class ScoringPage extends StatelessWidget {
  const ScoringPage({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Text(
                    'Your Final Score is',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                score.toString(),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60.h),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Explore your portfolio according to the Score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  String b = "";
                  if (score >= 34 && score <= 57) {
                    b = "Income with Capital Preservation";
                  } else if (score >= 58 && score <= 83) {
                    b = "Income with Moderate Growth";
                  } else if (score >= 84 && score <= 99) {
                    b = "Growth with Income";
                  } else if (score >= 100 && score <= 114) {
                    b = "Growth";
                  } else if (score >= 115 && score <= 125) {
                    b = "Aggressive Growth";
                  }
                  if (b.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(portfolioScoreName: b)));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff38A07D),
                  shadowColor: const Color.fromARGB(255, 41, 117, 92),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const InvestorScoreInfoScreen()));
                },
                child: const Text(
                  'How are we calculating the score?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
