import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../providers/quiz_provider.dart';
import '../../config/app_routes.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    // Watch for game over to navigate
    if (quizState.isGameOver) {
      Future.microtask(() => Get.offNamed(AppRoutes.result));
    }

    if (quizState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizState.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${quizState.error}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (quizState.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available.')),
      );
    }

    final currentQuestion = quizState.questions[quizState.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${quizState.currentIndex + 1}/${quizState.questions.length}'),
        actions: [
          Row(
            children: List.generate(
              3,
              (index) => Icon(
                index < quizState.lives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (quizState.currentIndex + 1) / quizState.questions.length,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      currentQuestion.category,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentQuestion.question,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: currentQuestion.allAnswers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final answer = currentQuestion.allAnswers[index];
                  return _buildAnswerButton(
                    context: context,
                    answer: answer,
                    quizState: quizState,
                    correctAnswer: currentQuestion.correctAnswer,
                    onTap: () => ref.read(quizProvider.notifier).answerQuestion(answer),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: quizState.selectedAnswer != null ? null : () => ref.read(quizProvider.notifier).skipQuestion(),
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text('Skip Question (-5 Marks)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton({
    required BuildContext context,
    required String answer,
    required QuizState quizState,
    required String correctAnswer,
    required VoidCallback onTap,
  }) {
    Color? backgroundColor;
    Color? foregroundColor;

    if (quizState.selectedAnswer != null) {
      if (answer == correctAnswer) {
        backgroundColor = Colors.green;
        foregroundColor = Colors.white;
      } else if (answer == quizState.selectedAnswer) {
        backgroundColor = Colors.red;
        foregroundColor = Colors.white;
      }
    }

    return ElevatedButton(
      onPressed: quizState.selectedAnswer != null ? null : onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
        disabledBackgroundColor: backgroundColor,
        disabledForegroundColor: foregroundColor,
      ),
      child: Text(
        answer,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }
}
