import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../config/app_routes.dart';
import '../../providers/quiz_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isAdminMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton.filledTonal(
                  onPressed: () {
                    Get.changeThemeMode(
                        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  },
                  icon: Icon(Get.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'TriviaX',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const Text('Test Your Knowledge, Challenge Your Mind'),
              const Spacer(),
              _buildCategoryCard(
                title: 'Quick Play',
                subtitle: 'Random questions from the API',
                icon: Icons.play_arrow_rounded,
                onTap: () => _showDifficultyPicker(context),
              ),
              const SizedBox(height: 16),
              _buildCategoryCard(
                title: 'Custom Quiz',
                subtitle: 'Play user-created questions',
                icon: Icons.dashboard_customize_rounded,
                onTap: () {
                  ref.read(quizProvider.notifier).startCustomQuiz();
                  Get.toNamed(AppRoutes.quiz);
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Admin mode',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Switch(
                    value: _isAdminMode,
                    onChanged: (val) {
                      setState(() => _isAdminMode = val);
                      if (val) Get.toNamed(AppRoutes.admin);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Difficulty',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _difficultyButton('Easy', Colors.green, 'easy'),
                  _difficultyButton('Medium', Colors.orange, 'medium'),
                  _difficultyButton('Hard', Colors.red, 'hard'),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyButton(String label, Color color, String value) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: () {
            Get.back();
            ref.read(quizProvider.notifier).startApiQuiz(value);
            Get.toNamed(AppRoutes.quiz);
          },
          icon: const Icon(Icons.bolt_rounded),
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.2),
            foregroundColor: color,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
