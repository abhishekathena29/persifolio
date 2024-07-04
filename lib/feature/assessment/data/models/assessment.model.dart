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
  String title;
  List<Option> options;
  int questionNo;
  Question({
    required this.heading,
    required this.title,
    required this.options,
    required this.questionNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'options': options.map((x) => x.toMap()).toList(),
      'questionNo': questionNo,
      'heading': heading
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        heading: map['heading'] ?? '',
        title: map['title'] ?? '',
        options:
            List<Option>.from(map['options']?.map((x) => Option.fromMap(x))),
        questionNo: map['questionNo'] ?? 0);
  }
}

class Option {
  String option;
  int score;
  Option({
    required this.option,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'option': option,
      'score': score,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      option: map['option'] ?? '',
      score: map['score']?.toInt() ?? 0,
    );
  }
}
