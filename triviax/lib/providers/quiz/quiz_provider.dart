import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_providers.dart';
import 'quiz_notifier.dart';
import 'quiz_state.dart';

export 'quiz_notifier.dart';
export 'quiz_state.dart';

// Quiz Provider
final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.watch(quizRepositoryProvider));
});
