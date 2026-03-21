import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/domain/calories_goal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/domain/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProgressbar extends StatelessWidget {
  const MainProgressbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final calories = ref.watch(dailySummaryProvider).calories;
        final goal = ref.watch(calorieGoalProvider);
        return LinearProgressIndicator(
          value: (calories / goal).clamp(0.0, 1.0),
          minHeight: 12,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.white,
          color: calories > goal ? Colors.red : Colors.green,
        );
      },
    );
  }
}
