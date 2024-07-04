import 'package:persifolio/feature/assessment/data/models/assessment.model.dart';

List<Assessment> onboarding = [
  Assessment(title: 'Time Horizon', question: timeHorizon),
  Assessment(title: 'Financial Goals', question: financialGoals),
  Assessment(title: 'Risk Tolerance', question: timeHorizon),
];

List<Question> timeHorizon = [
  Question(
    questionNo: 1,
    heading: 'Time Horizon',
    title: 'What is your age?',
    options: [
      Option(option: '56 and over', score: 1),
      Option(option: '46-55', score: 2),
      Option(option: '36-45', score: 3),
      Option(option: '20-35', score: 4),
    ],
  ),
  Question(
    questionNo: 2,
    heading: 'Time Horizon',
    title: 'What is your primary financial goal?',
    options: [
      Option(option: 'Wealth preservation', score: 1),
      Option(option: 'Retirement planning', score: 2),
      Option(option: 'Wealth accumulation', score: 3),
    ],
  ),
  Question(
    questionNo: 3,
    heading: 'Time Horizon',
    title: 'What is the time frame for you to achieve your financial goals?',
    options: [
      Option(option: '0-5 years', score: 1),
      Option(option: '5-10 years', score: 2),
      Option(option: '10 years or longer', score: 3),
    ],
  ),
];

List<Question> financialGoals = [
  Question(
    questionNo: 4,
    heading: 'Financial Goals',
    title: 'Which of the following best describes your financial goals?',
    options: [
      Option(
          option:
              'Preserving principal and earning a moderate amount of current income',
          score: 1),
      Option(option: 'Generating a high amount of current income', score: 2),
      Option(
          option:
              'Generating some current income and growing assets over an extended time frame',
          score: 3),
      Option(
          option: 'Growing assets substantially over an extended time frame',
          score: 4),
    ],
  ),
  Question(
    questionNo: 5,
    heading: 'Financial Goals',
    title:
        'How do you expect your standard of living five years from now to compare to your standard of living today?',
    options: [
      Option(option: 'Less than it is today', score: 1),
      Option(
          option: 'The same as it is todayThe same as it is today', score: 2),
      Option(option: 'Somewhat higher than it is today', score: 3),
      Option(option: 'Substantially greater than it is today', score: 4),
    ],
  ),
];
