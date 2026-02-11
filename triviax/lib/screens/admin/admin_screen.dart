import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../providers/quiz_provider.dart';
import '../../data/models/question_model.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customQuestions = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Quiz Builder'),
        actions: [
          IconButton(
            onPressed: () => _showAddQuestionDialog(context, ref),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: customQuestions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Text('No custom questions yet.'),
                   const SizedBox(height: 16),
                   ElevatedButton(
                     onPressed: () => _showAddQuestionDialog(context, ref),
                     child: const Text('Add My First Question'),
                   )
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customQuestions.length,
              itemBuilder: (context, index) {
                final q = customQuestions[index];
                return Dismissible(
                  key: Key(q.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(adminProvider.notifier).deleteQuestion(q.id);
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => _showAddQuestionDialog(context, ref, questionToEdit: q),
                      title: Text(q.question),
                      subtitle: Text('Answer: ${q.correctAnswer}'),
                      trailing: const Icon(Icons.edit_note_rounded),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Limit: ${customQuestions.length}/10',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }

  void _showAddQuestionDialog(BuildContext context, WidgetRef ref, {Question? questionToEdit}) {
    if (questionToEdit == null && ref.read(adminProvider).length >= 10) {
      Get.snackbar('Limit Reached', 'You can only add up to 10 questions.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final qController = TextEditingController(text: questionToEdit?.question);
    final aController = TextEditingController(text: questionToEdit?.correctAnswer);
    final i1Controller = TextEditingController(text: questionToEdit?.incorrectAnswers.getRange(0, 1).first ?? '');
    final i2Controller = TextEditingController(text: questionToEdit?.incorrectAnswers.length != null && questionToEdit!.incorrectAnswers.length > 1 ? questionToEdit.incorrectAnswers[1] : '');
    final i3Controller = TextEditingController(text: questionToEdit?.incorrectAnswers.length != null && questionToEdit!.incorrectAnswers.length > 2 ? questionToEdit.incorrectAnswers[2] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(questionToEdit == null ? 'New Question' : 'Edit Question'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: qController, decoration: const InputDecoration(labelText: 'Question Text')),
              TextField(controller: aController, decoration: const InputDecoration(labelText: 'Correct Answer')),
              TextField(controller: i1Controller, decoration: const InputDecoration(labelText: 'Incorrect Answer 1')),
              TextField(controller: i2Controller, decoration: const InputDecoration(labelText: 'Incorrect Answer 2')),
              TextField(controller: i3Controller, decoration: const InputDecoration(labelText: 'Incorrect Answer 3')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (qController.text.isEmpty || aController.text.isEmpty) return;
              
              final newQuestion = Question(
                id: questionToEdit?.id ?? DateTime.now().toIso8601String(),
                category: 'Custom',
                type: 'multiple',
                difficulty: 'medium',
                question: qController.text,
                correctAnswer: aController.text,
                incorrectAnswers: [
                  i1Controller.text,
                  i2Controller.text,
                  i3Controller.text,
                ],
              );
              
              if (questionToEdit == null) {
                ref.read(adminProvider.notifier).addQuestion(newQuestion);
              } else {
                ref.read(adminProvider.notifier).updateQuestion(newQuestion);
              }
              Get.back();
            },
            child: Text(questionToEdit == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
