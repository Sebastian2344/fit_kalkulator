import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/domain/calories_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaloriesGoalWidget extends ConsumerWidget {
  const CaloriesGoalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(calorieGoalProvider);
    return Text(
      "Cel: $goal kcal",
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
