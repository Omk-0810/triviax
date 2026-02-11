import 'package:flutter/material.dart';

class DifficultyButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DifficultyButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: onTap,
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
