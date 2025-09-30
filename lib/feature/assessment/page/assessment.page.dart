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
  int currentPageIndex = 0;

  @override
  void initState() {
    controller = PageController();
    getQuestionFirebase();
    super.initState();
  }

  bool isLoading = false;
  getQuestionFirebase() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var ques = await FirebaseFirestore.instance
          .collection('assessment')
          .orderBy('questionNo')
          .get();
      questionList =
          ques.docs.map((element) => Question.fromMap(element.data())).toList();
    } catch (e) {
      print('Error fetching questions: $e');
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<int, int> mp = {};
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Investment Assessment',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Column(
                children: [
                  // Progress Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Assessment Progress',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Complete',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: questionList.isEmpty
                              ? 0
                              : currentPageIndex / (questionList.length - 1),
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4CAF50)),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: controller,
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                          if (index == questionList.length - 1) {
                            isLast = true;
                          } else {
                            isLast = false;
                          }
                        });
                      },
                      itemCount: questionList.length,
                      itemBuilder: (context, index) {
                        var question = questionList[index];
                        return QuestionPage(
                          controller: controller,
                          question: question,
                          changeScore: (val) {
                            mp[question.questionNo] =
                                val * question.questionType;
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuestionNavigationButton(
                          controller: controller,
                          right: false,
                        ),
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
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScoringPage(score: totalScore)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
