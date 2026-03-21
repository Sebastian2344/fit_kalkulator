import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/domain/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelButton extends ConsumerWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(calcInDialogProvider.notifier).reset();
        Navigator.pop(context);
      },
      child: const Text("Anuluj"),
    );
  }
}
