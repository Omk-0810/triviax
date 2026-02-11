import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/question_model.dart';
import '../data/repositories/quiz_repository.dart';

class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final int lives;
  final bool isGameOver;
  final bool isLoading;
  final String? error;
  final String? selectedAnswer; // Nuw: track selection for feedback
  final bool? isCorrect;         // New: track if selection was correct

  QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.lives = 3,
    this.isGameOver = false,
    this.isLoading = false,
    this.error,
    this.selectedAnswer,
    this.isCorrect,
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    int? score,
    int? lives,
    bool? isGameOver,
    bool? isLoading,
    String? error,
    String? selectedAnswer,
    bool? isCorrect,
    bool clearSelection = false,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isGameOver: isGameOver ?? this.isGameOver,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedAnswer: clearSelection ? null : (selectedAnswer ?? this.selectedAnswer),
      isCorrect: clearSelection ? null : (isCorrect ?? this.isCorrect),
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizRepository _repository;

  QuizNotifier(this._repository) : super(QuizState());

  Future<void> startApiQuiz(String difficulty) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questions = await _repository.getApiQuestions(difficulty: difficulty);
      state = QuizState(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void startCustomQuiz() {
    final questions = _repository.getCustomQuestions();
    if (questions.isEmpty) {
      state = state.copyWith(error: "No custom questions found. Create some in Admin Mode!");
      return;
    }
    state = QuizState(questions: questions);
  }

  Future<void> answerQuestion(String answer) async {
    if (state.isGameOver || state.selectedAnswer != null) return;

    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = answer == currentQuestion.correctAnswer;

    // Show feedback
    state = state.copyWith(selectedAnswer: answer, isCorrect: isCorrect);

    // Wait for 1 second so user sees the color
    await Future.delayed(const Duration(milliseconds: 1000));

    if (isCorrect) {
      final newScore = state.score + 10;
      _nextQuestion(newScore, state.lives);
    } else {
      final newLives = state.lives - 1;
      if (newLives <= 0) {
        state = state.copyWith(lives: 0, isGameOver: true);
      } else {
        _nextQuestion(state.score, newLives);
      }
    }
  }

  void skipQuestion() {
    if (state.isGameOver || state.selectedAnswer != null) return;
    
    // Requirement: Skipping deducts marks (e.g., -5)
    final newScore = (state.score - 5).clamp(0, 9999);
    _nextQuestion(newScore, state.lives);
  }

  void _nextQuestion(int score, int lives) {
    if (state.currentIndex + 1 < state.questions.length) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        score: score,
        lives: lives,
        clearSelection: true,
      );
    } else {
      state = state.copyWith(
        score: score,
        lives: lives,
        isGameOver: true,
      );
    }
  }

  void resetQuiz() {
    state = QuizState();
  }
}

final quizRepositoryProvider = Provider((ref) => QuizRepository());

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.watch(quizRepositoryProvider));
});

// Admin Provider for managing custom questions
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

final adminProvider = StateNotifierProvider<AdminNotifier, List<Question>>((ref) {
  return AdminNotifier(ref.watch(quizRepositoryProvider));
});
