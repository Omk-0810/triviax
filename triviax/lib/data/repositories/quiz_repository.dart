import '../models/question_model.dart';
import '../services/api_service.dart';

class QuizRepository {
  final ApiService _apiService = ApiService();
  
  // In-memory list for custom questions (Admin Mode)
  final List<Question> _customQuestions = [];

  Future<List<Question>> getApiQuestions({String difficulty = 'easy'}) async {
    return await _apiService.fetchQuestions(difficulty: difficulty);
  }

  List<Question> getCustomQuestions() {
    return List.unmodifiable(_customQuestions);
  }

  void addCustomQuestion(Question question) {
    if (_customQuestions.length < 10) {
      _customQuestions.add(question);
    }
  }

  void deleteCustomQuestion(String id) {
    _customQuestions.removeWhere((q) => q.id == id);
  }

  void updateCustomQuestion(Question question) {
    final index = _customQuestions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _customQuestions[index] = question;
    }
  }
}
