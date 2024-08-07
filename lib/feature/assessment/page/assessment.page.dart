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

  bool isLoading = false;
  getQuestionFirebase() async {
    setState(() {
      isLoading = true;
    });
    var ques = await FirebaseFirestore.instance
        .collection('assessment')
        .orderBy('questionNo')
        .get();
    questionList =
        ques.docs.map((element) => Question.fromMap(element.data())).toList();
    setState(() {
      isLoading = false;
    });
  }

  Map<int, int> mp = {};
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     mp.forEach((u, v) {
      //       totalScore += v;
      //     });
      //     print(isLast);
      //   },
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller,
                      // physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        if (index == questionList.length - 1) {
                          isLast = true;
                        } else {
                          isLast = false;
                        }
                        setState(() {});
                      },
                      itemCount: questionList.length,
                      itemBuilder: (context, index) {
                        // if (index == questionList.length - 1) {
                        //   isLast = true;
                        // }
                        var question = questionList[index];
                        // int score = 0;
                        return QuestionPage(
                          controller: controller,
                          question: question,
                          changeScore: (val) {
                            // score = val;
                            mp[question.questionNo] =
                                val * question.questionType;
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
                      // if (!isLast)
                      if (!isLast)
                        QuestionNavigationButton(
                          controller: controller,
                          right: true,
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            int totalScore = 0;
                            mp.forEach((u, v) {
                              totalScore += v;
                              // print(u.toString() + " " + v.toString());
                            });
                            // print(totalScore);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScoringPage(score: totalScore)));
                          },
                          child: const Text("Submit"),
                        )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
