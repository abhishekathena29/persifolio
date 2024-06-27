import 'package:flutter/material.dart';
import 'package:persifolio/feature/assessment/data/local/dummy.data.dart';

class TimeHorizonAssessment extends StatefulWidget {
  const TimeHorizonAssessment({super.key});

  @override
  State<TimeHorizonAssessment> createState() => _TimeHorizonAssessmentState();
}

class _TimeHorizonAssessmentState extends State<TimeHorizonAssessment> {
  String? type;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: PageView(
            children: timeHorizon
                .map(
                  (ques) => Column(
                    children: [
                      Text(
                        ques.title,
                        style: const TextStyle(
                          fontSize: 17,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
