import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalcDataCalories extends ConsumerWidget {
  const CalcDataCalories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcData = ref.watch(calcInDialogProvider);
    if (calcData.product.name == "") return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(
            "${calcData.calories} kcal",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniMacro("Białko", calcData.protein, Colors.blue),
              _miniMacro("Tłuszcze", calcData.fat, Colors.orange),
              _miniMacro("Węgle", calcData.carbs, Colors.brown),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniMacro(String label, double val, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${val.toStringAsFixed(1)}g",
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
