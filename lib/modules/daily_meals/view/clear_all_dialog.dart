import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClearAllDialog extends ConsumerWidget {
  const ClearAllDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Wyczyść dziennik?"),
      content: const Text(
        "Czy na pewno chcesz usunąć wszystkie posiłki z dziennika?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Anuluj
          child: const Text("Anuluj"),
        ),
        ElevatedButton(
          onPressed: () {
            // Tutaj dodaj logikę czyszczenia dziennika
            ref.read(dailyMealsProvider.notifier).clearMeals();
            Navigator.pop(context); // Zamknij dialog
          },
          child: const Text("Wyczyść"),
        ),
      ],
    );
  }
}
