import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/view/calories_goal_widget.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCalorieGoal extends CalorieGoal {
  final int _initialGoal;
  
  FakeCalorieGoal(this._initialGoal);

  @override
  int build() => _initialGoal; // Podmieniamy wartość początkową
}

void main() {
  // Przerabiamy funkcję tak, aby przyjmowała docelową wartość kalorii
  Widget createTestWidget(int goalCalories) {
    return ProviderScope(
      overrides:[
        // Nadpisujemy wygenerowany provider naszym Fake'iem
        calorieGoalProvider.overrideWith(() => FakeCalorieGoal(goalCalories)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: CaloriesGoalWidget(),
        ),
      ),
    );
  }

  testWidgets('Powinien wyświetlić "Cel: 0 kcal", gdy brak kalorii', (tester) async {
    await tester.pumpWidget(createTestWidget(0));
    expect(find.text('Cel: 0 kcal'), findsOneWidget);
  });

  testWidgets('Powinien wyświetlić poprawną ilość kalorii Cel', (tester) async {
    await tester.pumpWidget(createTestWidget(1850));
    expect(find.text('Cel: 1850 kcal'), findsOneWidget);
  });

  testWidgets('Powinien posiadać pogrubiony styl czcionki', (tester) async {
    await tester.pumpWidget(createTestWidget(1850)); // Musi mieć zainicjowany stan!

    // Szukamy konkretnego tekstu, żeby uniknąć błędu z "multiple widgets"
    final finder = find.text('Cel: 1850 kcal');
    expect(finder, findsOneWidget);

    // Wyciągamy znaleziony widget Text
    final textWidget = tester.widget<Text>(finder);
    
    expect(textWidget.style?.fontWeight, FontWeight.bold);
  });
}