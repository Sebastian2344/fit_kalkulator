import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowGoalDialog extends ConsumerStatefulWidget {
  const ShowGoalDialog({super.key});

  @override
  ConsumerState<ShowGoalDialog> createState() => _ShowGoalDialogState();
}

class _ShowGoalDialogState extends ConsumerState<ShowGoalDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Inicjalizujemy kontroler TYLKO RAZ, odczytując wartość z providera
    final initialGoal = ref.read(calorieGoalProvider).toString();
    _controller = TextEditingController(text: initialGoal);
  }

  @override
  void dispose() {
    // Pamiętamy o zwolnieniu pamięci
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Zmień cel kalorii"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters:[FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(suffixText: "kcal"),
      ),
      actions:[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Anuluj"),
        ),
        FilledButton(
          onPressed: () {
            final val = int.tryParse(_controller.text);
            if (val != null && val > 0) {
              // Używamy ref prosto z ConsumerState
              ref.read(calorieGoalProvider.notifier).setGoal(val);
              Navigator.pop(context);
            }
          },
          child: const Text("Zapisz"),
        ),
      ],
    );
  }
}