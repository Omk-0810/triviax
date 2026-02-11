import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/quiz_repository.dart';

final quizRepositoryProvider = Provider((ref) => QuizRepository());
