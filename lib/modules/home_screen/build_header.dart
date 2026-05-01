import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/view/calories_goal_widget.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/view/show_goal_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/view/calories_summary.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/view/macros_belts.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/view/main_progressbar.dart';
import 'package:flutter/material.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Górna linia z celem (klikana do edycji)
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    const ShowGoalDialog(),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CaloriesSummary(),
                Row(
                  children: [
                    const CaloriesGoalWidget(),
                    const SizedBox(width: 4),
                    const Icon(Icons.edit, size: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Główny pasek postępu
          const MainProgressbar(),
          const SizedBox(height: 15),
          // Paski Makroskładników (Białko, Tłuszcze, Węgle)
          const MacrosBelts()
        ],
      ),
    );
  }
}