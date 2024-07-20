import 'package:persifolio/feature/assessment/data/models/assessment.model.dart';

List<Assessment> onboarding = [
  Assessment(title: 'Time Horizon', question: timeHorizon),
  Assessment(title: 'Financial Goals', question: financialGoals),
  Assessment(title: 'Risk Tolerance', question: timeHorizon),
];

List<Question> timeHorizon = [
  Question(
    questionNo: 1,
    questionType: 1,
    heading: 'Time Horizon',
    title: 'What is your age?',
    options: [
      Option(optionText: '56 and over', score: 1),
      Option(optionText: '46-55', score: 2),
      Option(optionText: '36-45', score: 3),
      Option(optionText: '20-35', score: 4),
    ],
  ),
  Question(
    questionNo: 2,
    questionType: 1,
    heading: 'Time Horizon',
    title: 'What is your primary financial goal?',
    options: [
      Option(optionText: 'Wealth preservation', score: 1),
      Option(optionText: 'Retirement planning', score: 2),
      Option(optionText: 'Wealth accumulation', score: 3),
    ],
  ),
  Question(
    questionNo: 3,
    questionType: 1,
    heading: 'Time Horizon',
    title: 'What is the time frame for you to achieve your financial goals?',
    options: [
      Option(optionText: '0-5 years', score: 1),
      Option(optionText: '5-10 years', score: 2),
      Option(optionText: '10 years or longer', score: 3),
    ],
  ),
  Question(
    questionNo: 4,
    questionType: 2,
    heading: 'Financial Goals',
    title: 'Which of the following best describes your financial goals?',
    options: [
      Option(
          optionText:
              'Preserving principal and earning a moderate amount of current income',
          score: 1),
      Option(
          optionText: 'Generating a high amount of current income', score: 2),
      Option(
          optionText:
              'Generating some current income and growing assets over an extended time frame',
          score: 3),
      Option(
          optionText:
              'Growing assets substantially over an extended time frame',
          score: 4),
    ],
  ),
  Question(
    questionNo: 5,
    questionType: 2,
    heading: 'Financial Goals',
    title:
        'How do you expect your standard of living five years from now to compare to your standard of living today?',
    options: [
      Option(optionText: 'Less than it is today', score: 1),
      Option(
          optionText: 'The same as it is todayThe same as it is today',
          score: 2),
      Option(optionText: 'Somewhat higher than it is today', score: 3),
      Option(optionText: 'Substantially greater than it is today', score: 4),
    ],
  ),
  Question(
    heading: 'Financial Goals',
    questionType: 2,
    title: 'Five years from today, you expect your portfolio value to be:',
    questionNo: 6,
    options: [
      Option(
          optionText:
              'Portfolio value is not my primary concern; I am more concerned with current income',
          score: 1),
      Option(
          optionText: 'The same as or slightly more than it is today',
          score: 2),
      Option(optionText: 'Greater than it is today', score: 3),
      Option(optionText: 'Substantially greater than it is today', score: 4),
    ],
  ),
  Question(
    heading: 'Financial Goals',
    questionType: 2,
    title: 'Generating current income from your portfolio is:',
    questionNo: 7,
    options: [
      Option(
          optionText: 'A primary concern (only if you are about to retire)',
          score: 1),
      Option(optionText: 'Not important', score: 2),
    ],
  ),
  Question(
    heading: 'Financial Goals',
    questionType: 2,
    title: 'With the income generated from your portfolio, you plan to:',
    questionNo: 8,
    options: [
      Option(optionText: 'Use it for living expenses.', score: 1),
      Option(optionText: 'Use some and reinvest some', score: 2),
      Option(optionText: 'Reinvest all income', score: 2),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title:
        'You have just received a large amount of money. How would you invest it?',
    questionNo: 9,
    options: [
      Option(
          optionText:
              'I would invest in something that offered moderate current income and was very conservative',
          score: 1),
      Option(
          optionText:
              'I would invest in something that offered high current income with a moderate amount of risk',
          score: 2),
      Option(
        optionText:
            'I would invest in something that offered high total return (current income plus capital appreciation) with a moderately high amount of risk',
        score: 3,
      ),
      Option(
        optionText:
            'I would invest in something that offered substantial capital appreciation even though it has a high amount of risk',
        score: 4,
      ),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title:
        'Which of the following statements would best describe your reaction if the value of your portfolio were to suddenly decline by 15%?',
    questionNo: 10,
    options: [
      Option(
          optionText:
              'I would be very concerned because I cannot accept fluctuations in the value of my portfolio.',
          score: 1),
      Option(
          optionText:
              'If the amount of income I receive was unaffected, it would not bother me',
          score: 2),
      Option(
        optionText:
            'I invest for long-term growth, so I would be concerned about even a temporary decline',
        score: 3,
      ),
      Option(
        optionText:
            'Because I invest for long-term growth, I would accept temporary fluctuations due to market influences.',
        score: 4,
      ),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title:
        'Which of the following investments would you feel most comfortable owning?',
    questionNo: 11,
    options: [
      Option(optionText: 'Certificates of deposit', score: 1),
      Option(optionText: 'U.S. Government securities', score: 2),
      Option(
        optionText: 'Blue-chip stocks',
        score: 3,
      ),
      Option(
        optionText: 'Stocks of new growth companies',
        score: 4,
      ),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title: 'Which of the following investments would you least like to own?',
    questionNo: 12,
    options: [
      Option(optionText: 'Stocks of new growth companies.', score: 1),
      Option(optionText: 'Blue-chip stocks', score: 2),
      Option(
        optionText: 'U.S. Government securities',
        score: 3,
      ),
      Option(
        optionText: 'Certificates of deposit',
        score: 4,
      ),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title:
        'Which of the following investments do you feel are the most ideal for your portfolio?',
    questionNo: 13,
    options: [
      Option(optionText: 'Certificates of deposit', score: 1),
      Option(optionText: 'U.S. Government securities', score: 2),
      Option(
        optionText: 'Blue-chip stocks',
        score: 3,
      ),
      Option(
        optionText: 'Stocks of new growth companies',
        score: 4,
      ),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title:
        'How optimistic are you about the long-term prospects for the economy?',
    questionNo: 14,
    options: [
      Option(optionText: 'Very pessimistic', score: 1),
      Option(optionText: 'Unsure', score: 2),
      Option(
        optionText: 'Somewhat optimistic',
        score: 3,
      ),
      Option(
        optionText: 'Very optimistic',
        score: 4,
      ),
    ],
  ),
  Question(
    heading: 'Risk Tolerance',
    questionType: 3,
    title:
        'Which of the following best describes your attitude about investments outside the U.S.?',
    questionNo: 15,
    options: [
      Option(optionText: 'Unsure', score: 1),
      Option(
          optionText:
              'I believe the U.S. economy and foreign markets are interdependent',
          score: 2),
      Option(
          optionText:
              'I believe overseas markets provide attractive investment opportunities',
          score: 3),
    ],
  ),
];

List<Question> financialGoals = [];
