import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowGoalDialog extends ConsumerWidget {
  const ShowGoalDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: ref.read(calorieGoalProvider).toString());
    return AlertDialog(
      title: const Text("Zmień cel kalorii"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(suffixText: "kcal"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Anuluj"),
        ),
        Consumer(
          builder: (context, ref, child) => FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                ref.read(calorieGoalProvider.notifier).setGoal(val);
                Navigator.pop(context);
              }
            },
            child: const Text("Zapisz"),
          ),
        ),
      ],
    );
  }
}
