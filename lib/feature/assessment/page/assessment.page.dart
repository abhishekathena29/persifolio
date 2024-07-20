import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persifolio/feature/assessment/widget/question_page.dart';
import 'package:persifolio/feature/scoring/scoring_page.dart';

import '../data/models/assessment.model.dart';
import '../widget/page_navigation.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  List<Question> questionList = [];
  final assessmentColl =
      FirebaseFirestore.instance.collection('assessment').get();

  late final PageController controller;
  @override
  void initState() {
    controller = PageController();
    getQuestionFirebase();
    super.initState();
  }

  getQuestionFirebase() async {
    var ques = await FirebaseFirestore.instance
        .collection('assessment')
        .orderBy('questionNo')
        .get();
    questionList =
        ques.docs.map((element) => Question.fromMap(element.data())).toList();
    setState(() {});
  }

  int totalScore = 0;
  Map<int, int> mp = {};
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mp.forEach((u, v) {
            totalScore += v;
          });
          print(isLast);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: questionList.length,
                itemBuilder: (context, index) {
                  if (index == questionList.length - 1) {
                    isLast = true;
                  }
                  var question = questionList[index];
                  int score = 0;
                  return QuestionPage(
                    controller: controller,
                    question: question,
                    changeScore: (val) {
                      score = val;
                      mp[question.questionNo] = score * question.questionType;
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuestionNavigationButton(
                  controller: controller,
                  right: false,
                ),
                QuestionNavigationButton(
                  controller: controller,
                  right: true,
                ),
                if (isLast)
                  ElevatedButton(onPressed: () {}, child: const Text("Submit"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
