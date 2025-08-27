import 'package:flutter/material.dart';
import '../data/models/assessment.model.dart';

class QuestionPage extends StatefulWidget {
  final PageController controller;
  final Question question;
  final Function(int) changeScore;

  const QuestionPage({
    super.key,
    required this.controller,
    required this.question,
    required this.changeScore,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                                     child: const Icon(
                     Icons.quiz,
                     color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Question',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Question Text
            Text(
              widget.question.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Options
            ...widget.question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedOption == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = index;
                  });
                  widget.changeScore(index + 1);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                                       color: isSelected 
                       ? const Color(0xFF4CAF50).withOpacity(0.2)
                       : const Color(0xFF0F0F0F),
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(
                     color: isSelected 
                         ? const Color(0xFF4CAF50)
                         : Colors.grey.shade800,
                      width: 2,
                    ),
                    boxShadow: [
                                           BoxShadow(
                       color: isSelected 
                           ? const Color(0xFF4CAF50).withOpacity(0.3)
                           : Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                                                   color: isSelected 
                             ? const Color(0xFF4CAF50)
                             : Colors.transparent,
                         border: Border.all(
                           color: isSelected 
                               ? const Color(0xFF4CAF50)
                               : Colors.grey.shade600,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option.optionText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 32),
            
            // Help Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                children: [
                                   Icon(
                   Icons.info_outline,
                   color: const Color(0xFF4CAF50).withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select the option that best describes your investment preferences',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
