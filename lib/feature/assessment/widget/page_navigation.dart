import 'package:flutter/material.dart';

class QuestionNavigationButton extends StatelessWidget {
  const QuestionNavigationButton({
    super.key,
    required this.controller,
    required this.right,
  });

  final PageController controller;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (right) {
          controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        } else {
          controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xff38A07D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!right)
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            Text(
              right ? "Next " : "Back ",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            if (right)
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
