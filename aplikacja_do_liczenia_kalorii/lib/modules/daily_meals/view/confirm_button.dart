import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ConfirmButton extends ConsumerWidget {
  const ConfirmButton({super.key, required this.weightController});
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
          onPressed: () {
            final weight = int.tryParse(weightController.text) ?? 0;
            final calcData = ref.read(calcInDialogProvider);
            if (calcData.product.name != "" && weight > 0) {
              final meal = Meal(
                name: calcData.product.name,
                weight: weight,
                calories: calcData.calories,
                protein: calcData.protein,
                fat: calcData.fat,
                carbs: calcData.carbs,
                date: DateTime.now(),
              );

              ref.read(dailyMealsProvider.notifier).addMeal(meal);
              ref.read(calcInDialogProvider.notifier).reset();
              Navigator.pop(context);
            }
          },
          child: const Text("Zatwierdź"),
        );
  }
}