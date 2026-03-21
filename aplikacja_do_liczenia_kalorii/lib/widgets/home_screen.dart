import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/view/calculator.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/selected_product_list.dart';
import 'package:aplikacja_do_liczenia_kalorii/widgets/add_meal_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/widgets/build_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitKalkulator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            tooltip: "Kalkulator Kalorii",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalculatorScreen()),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.account_circle_outlined),
          const SizedBox(width: 12),
        ],
      ),
      body: const Column(
        children: [
          BuildHeader(),
          SelectedProductList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddMealDialog(),
        ),
        label: const Text("Dodaj posiłek"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}