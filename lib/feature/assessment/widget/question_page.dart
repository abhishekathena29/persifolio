import 'package:flutter/material.dart';

import '../../scoring/scoring_page.dart';
import '../data/models/assessment.model.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    super.key,
    required this.question,
    required this.changeScore,
    required this.controller,
  });

  final Question question;
  final ValueChanged<int> changeScore;
  final PageController controller;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  int score = 0;
  String? type;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        Text(
          "Question: ${widget.question.questionNo}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          widget.question.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        ...widget.question.options.map(
          (e) => Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: RadioListTile(
              title: Text(e.optionText),
              value: e.optionText,
              groupValue: type,
              onChanged: (val) {
                setState(() {
                  type = val;
                  widget.changeScore(e.score);
                });
              },
              activeColor: const Color(0xff38A07D),
            ),
          ),
        ),
        if (widget.question.questionNo == 15)
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScoringPage()));
            },
            child: const Text('Submit'),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
