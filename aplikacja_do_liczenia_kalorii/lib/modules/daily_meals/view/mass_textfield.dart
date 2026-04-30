import 'package:aplikacja_do_liczenia_kalorii/core/debouncer.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MassTextfield extends ConsumerWidget {
  MassTextfield({super.key, required this.weightController});
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: weightController,
      onChanged: (v) {
        debouncer.run(() {
          ref
              .read(calcInDialogProvider.notifier)
              .recalculate(
                ref.read(calcInDialogProvider).product,
                weightController,
              );
        });
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: "Waga (g)",
        prefixIcon: Icon(Icons.scale),
      ),
    );
  }
}
