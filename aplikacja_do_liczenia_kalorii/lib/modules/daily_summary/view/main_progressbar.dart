import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/viewmodel/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProgressbar extends ConsumerWidget {
  const MainProgressbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calories = ref.watch(dailySummaryProvider).calories;
    final goal = ref.watch(calorieGoalProvider);
    return LinearProgressIndicator(
      value: (calories / goal).clamp(0.0, 1.0),
      minHeight: 12,
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.white,
      color: calories > goal ? Colors.red : Colors.green,
    );
  }
}
