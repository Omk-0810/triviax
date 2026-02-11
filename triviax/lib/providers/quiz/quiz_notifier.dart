import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/quiz_repository.dart';
import 'quiz_state.dart';

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizRepository _repository;

  QuizNotifier(this._repository) : super(QuizState());

  Future<void> startApiQuiz(String difficulty) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questions =
          await _repository.getApiQuestions(difficulty: difficulty);
      state = QuizState(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void startCustomQuiz() {
    final questions = _repository.getCustomQuestions();
    if (questions.isEmpty) {
      state = state.copyWith(
          error: "No custom questions found. Create some in Admin Mode!");
      return;
    }
    state = QuizState(questions: questions);
  }

  Future<void> answerQuestion(String answer) async {
    if (state.isGameOver || state.selectedAnswer != null) return;

    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = answer == currentQuestion.correctAnswer;

    state = state.copyWith(selectedAnswer: answer, isCorrect: isCorrect);

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
