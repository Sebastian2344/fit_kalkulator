import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/domain/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaloriesSummary extends StatelessWidget {
  const CaloriesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final calories = ref.watch(dailySummaryProvider).calories;
        return Text(
          "Zjedzone: $calories kcal",
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
