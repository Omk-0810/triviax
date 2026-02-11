import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/question_model.dart';
import '../common_providers.dart';
import 'admin_notifier.dart';

// Admin Provider
final adminProvider =
    StateNotifierProvider<AdminNotifier, List<Question>>((ref) {
  return AdminNotifier(ref.watch(quizRepositoryProvider));
});
