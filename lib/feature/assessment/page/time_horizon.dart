// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:persifolio/feature/assessment/data/local/dummy.data.dart';

// class TimeHorizonAssessment extends StatefulWidget {
//   const TimeHorizonAssessment({super.key});

//   @override
//   State<TimeHorizonAssessment> createState() => _TimeHorizonAssessmentState();
// }

// class _TimeHorizonAssessmentState extends State<TimeHorizonAssessment> {
//   String? type;
//   final timeHorizonController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: Size(1.sw, 0.1.sh),
//           child: Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
//             color: const Color(0xff38A07D),
//             child: const Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Time Horizon",
//                   style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: PageView(
//           controller: timeHorizonController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: timeHorizon
//               .map(
//                 (ques) => Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 50),
//                     Text(
//                       "Question: ${ques.questionNo}",
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       ques.title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ...ques.options.map(
//                       (e) => Container(
//                         margin: const EdgeInsets.only(bottom: 20),
//                         decoration: BoxDecoration(
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: RadioListTile(
//                           title: Text(e.optionText),
//                           value: e.optionText,
//                           groupValue: type,
//                           onChanged: (val) {
//                             setState(() {
//                               type = val;
//                             });
//                           },
//                           activeColor: const Color(0xff38A07D),
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     QuestionNavigationButton(
//                       timeHorizonController: timeHorizonController,
//                       right: true,
//                     ),
//                     const SizedBox(height: 30),
//                     QuestionNavigationButton(
//                       timeHorizonController: timeHorizonController,
//                       right: false,
//                     ),
//                     const SizedBox(height: 60),
//                   ],
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
