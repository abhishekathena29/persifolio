import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persifolio/feature/assessment/data/local/dummy.data.dart';
import 'package:persifolio/feature/assessment/page/time_horizon.dart';

class FinancialGoals extends StatefulWidget {
  const FinancialGoals({super.key});

  @override
  State<FinancialGoals> createState() => _FinancialGoalsState();
}

class _FinancialGoalsState extends State<FinancialGoals> {
  String? type;
  final financialGoalsController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(1.sw, 0.1.sh),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
            color: const Color(0xff38A07D),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Financial Goals",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PageView(
              controller: financialGoalsController,
              physics: const NeverScrollableScrollPhysics(),
              children: financialGoals
                  .map(
                    (ques) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          "Question: ${ques.questionNo}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ques.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...ques.options.map(
                          (e) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RadioListTile(
                              title: Text(e.option),
                              value: e.option,
                              groupValue: type,
                              onChanged: (val) {
                                setState(() {
                                  type = val;
                                });
                              },
                              activeColor: const Color(0xff38A07D),
                            ),
                          ),
                        ),
                        const Spacer(),
                        QuestionNavigationButton(
                          timeHorizonController: financialGoalsController,
                          right: true,
                        ),
                        const SizedBox(height: 30),
                        QuestionNavigationButton(
                          timeHorizonController: financialGoalsController,
                          right: false,
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
