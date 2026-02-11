import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/question_model.dart';
import '../../data/repositories/quiz_repository.dart';

class AdminNotifier extends StateNotifier<List<Question>> {
  final QuizRepository _repository;
  AdminNotifier(this._repository) : super(_repository.getCustomQuestions());

  void addQuestion(Question q) {
    _repository.addCustomQuestion(q);
    state = _repository.getCustomQuestions();
  }

  void deleteQuestion(String id) {
    _repository.deleteCustomQuestion(id);
    state = _repository.getCustomQuestions();
  }

  void updateQuestion(Question q) {
    _repository.updateCustomQuestion(q);
    state = _repository.getCustomQuestions();
  }
}
