class Assessment {
  String title;
  List<Question> question;
  Assessment({
    required this.title,
    required this.question,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'question': question.map((x) => x.toMap()).toList(),
    };
  }

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      title: map['title'] ?? '',
      question:
          List<Question>.from(map['question']?.map((x) => Question.fromMap(x))),
    );
  }
}

class Question {
  String heading;
  int questionType;
  String title;
  int questionNo;
  List<Option> options;
  Question({
    required this.heading,
    required this.questionType,
    required this.title,
    required this.questionNo,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'options': options.map((x) => x.toMap()).toList(),
      'questionNo': questionNo,
      'heading': heading,
      'questionType': questionType
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      heading: map['heading'] ?? '',
      title: map['title'] ?? '',
      options: List<Option>.from(map['options']?.map((x) => Option.fromMap(x))),
      questionNo: map['questionNo'] ?? 0,
      questionType: map['questionType'] ?? 0,
    );
  }
}

class Option {
  String optionText;
  int score;
  Option({
    required this.optionText,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'option': optionText,
      'score': score,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      optionText: map['option'] ?? '',
      score: map['score']?.toInt() ?? 0,
    );
  }
}
