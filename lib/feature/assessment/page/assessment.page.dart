import 'package:flutter/material.dart';
import 'package:persifolio/feature/assessment/data/local/dummy.data.dart';
import 'package:persifolio/feature/assessment/page/time_horizon.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        TimeHorizonAssessment(),
      ],
    );
  }
}
