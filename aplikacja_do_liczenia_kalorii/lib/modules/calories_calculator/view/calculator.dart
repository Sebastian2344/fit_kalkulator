import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/domain/activity_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/domain/calculator_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/domain/gender_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  void _calculate(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final stats = UserStats(
        gender: ref.read(genderProvider).result,
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        activityLevel: ref.read(activityLevelProvider).result,
      );

      // Wywołujemy kontroler widoku
      ref.read(calculatorControllerProvider.notifier).calculate(stats);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Kalorii'),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Resetuj',
                onPressed: () {
                  _ageController.clear();
                  _weightController.clear();
                  _heightController.clear();
                  ref.read(genderProvider.notifier).setGender(Gender.male);
                  ref
                      .read(activityLevelProvider.notifier)
                      .setActivityLevel(ActivityLevel.sedentary);
                  ref.read(calculatorControllerProvider.notifier).reset();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer(
                builder: (c, ref, child) {
                  final gender = ref.watch(genderProvider).result;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text('Mężczyzna'),
                        selected: gender == Gender.male,
                        onSelected: (val) => ref
                            .read(genderProvider.notifier)
                            .setGender(Gender.male),
                      ),
                      ChoiceChip(
                        label: const Text('Kobieta'),
                        selected: gender == Gender.female,
                        onSelected: (val) => ref
                            .read(genderProvider.notifier)
                            .setGender(Gender.female),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // DANE (Wiek, Waga, Wzrost)
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Wiek',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Podaj wiek' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Waga (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Podaj wagę' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Wzrost (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Podaj wzrost' : null,
              ),
              const SizedBox(height: 16),

              // POZIOM AKTsYWNOŚCI
              Consumer(
                builder: (c, ref, child) {
                  final activityLevel = ref.watch(activityLevelProvider).result;
                  return DropdownButtonFormField<ActivityLevel>(
                    initialValue: activityLevel,
                    decoration: const InputDecoration(
                      labelText: 'Poziom aktywności',
                      border: OutlineInputBorder(),
                    ),
                    items: ActivityLevel.values.map((lvl) {
                      return DropdownMenuItem(
                        value: lvl,
                        child: Text(
                          lvl.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null){
                        ref
                            .read(activityLevelProvider.notifier)
                            .setActivityLevel(val);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              Consumer(
                builder: (c, ref, child) =>
                ElevatedButton(
                  onPressed: () => _calculate(ref),
                  child: const Text('OBLICZ', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 32),
              Consumer(
                builder: (c, ref, child) {
                  final state = ref.watch(calculatorControllerProvider);
                  if (state.result == null) {
                    return const SizedBox.shrink();
                  }
                  return Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Wyniki:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'BMR: ${state.result!.bmr.toStringAsFixed(0)} kcal',
                          ),
                          Text(
                            'TDEE: ${state.result!.tdee.toStringAsFixed(0)} kcal',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
