import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/viewmodel/daily_summary.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/home_screen/macro_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MacrosBelts extends StatelessWidget {
  const MacrosBelts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final protein = ref.watch(dailySummaryProvider).protein;
              return MacroItem(
                label: 'białko',
                val: protein,
                color: Colors.blue,
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final fat = ref.watch(dailySummaryProvider).fat;
              return MacroItem(
                label: 'tłuszcze',
                val: fat,
                color: Colors.orange,
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final carbs = ref.watch(dailySummaryProvider).carbs;
              return MacroItem(label: 'węgle', val: carbs, color: Colors.brown);
            },
          ),
        ),
      ],
    );
  }
}
