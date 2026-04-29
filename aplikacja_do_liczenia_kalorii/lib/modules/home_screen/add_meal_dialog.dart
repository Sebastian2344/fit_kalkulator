import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/calc_data_calories.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/barcode_button.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/cancel_button.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/autocomplete_widget.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/confirm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMealDialog extends StatefulWidget {
  const AddMealDialog({super.key});

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.text = "100"; // Domyślna waga 100g
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Dodaj posiłek"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Row(
              children: [
                Expanded(
                  child: AutocompleteWidget(weightController: _weightController),
                ),
                const SizedBox(width: 8),
                BarcodeButton(weightController: _weightController),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Waga (g)",
                prefixIcon: Icon(Icons.scale),
              ),
            ),
            const SizedBox(height: 15),
            const CalcDataCalories()
          ],
        ),
      ),
      actions: [
        const CancelButton(),
        ConfirmButton(weightController: _weightController),
      ],
    );
  }
}