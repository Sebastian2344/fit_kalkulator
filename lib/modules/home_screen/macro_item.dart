import 'package:flutter/material.dart';

class MacroItem extends StatelessWidget {
  const MacroItem({
    super.key,
    required this.label,
    required this.val,
    required this.color,
  });
  final String label;
  final double val;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text("${val.toInt()}g", style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: (val / 150).clamp(
            0.0,
            1.0,
          ), // Zakładamy arbitralnie max 150g dla wizualizacji
          color: color,
          backgroundColor: Colors.white.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}