import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultWidget extends ConsumerWidget {
  const ResultWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorControllerProvider);// Debug
    if (state == null) {
      return const SizedBox.shrink();
    }
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Wyniki:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('BMR: ${state.bmr.toStringAsFixed(0)} kcal'),
            Text(
              'TDEE: ${state.tdee.toStringAsFixed(0)} kcal',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
