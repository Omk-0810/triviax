import '../../data/models/question_model.dart';

class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final int lives;
  final bool isGameOver;
  final bool isLoading;
  final String? error;
  final String? selectedAnswer;
  final bool? isCorrect;

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
      selectedAnswer:
          clearSelection ? null : (selectedAnswer ?? this.selectedAnswer),
      isCorrect: clearSelection ? null : (isCorrect ?? this.isCorrect),
    );
  }
}
