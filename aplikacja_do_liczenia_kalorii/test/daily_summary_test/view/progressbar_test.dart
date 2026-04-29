import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/view/main_progressbar.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/viewmodel/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importuj swoje modele i wygenerowane providery
// import 'package:your_app/daily_summary.dart'; 

void main() {
  // Pomocnicza funkcja do budowania widgetu z nadpisaniami
  Widget createTestWidget({
    required int calories,
    required int goal,
  }) {
    return ProviderScope(
      overrides: [
        // Nadpisujemy wygenerowany dailySummaryProvider
        dailySummaryProvider.overrideWith((ref) => DailySummary(calories, 0, 0, 0)),
        // Nadpisujemy wygenerowany calorieGoalProvider
        calorieGoalProvider.overrideWithValue(goal),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: MainProgressbar(),
        ),
      ),
    );
  }

  testWidgets('Should show 50% progress and green color when half the goal is reached', (tester) async {
    await tester.pumpWidget(createTestWidget(calories: 1000, goal: 2000));

    // Znajdź LinearProgressIndicator
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );

    // Sprawdź wartość: 1000 / 2000 = 0.5
    expect(indicator.value, 0.5);
    // Sprawdź kolor: poniżej celu -> zielony
    expect(indicator.color, Colors.green);
  });

  testWidgets('Should show 100% and red color when calories exceed the goal', (tester) async {
    await tester.pumpWidget(createTestWidget(calories: 3000, goal: 2500));

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );

    // Sprawdź clamp: 3000 / 2500 = 1.2, ale ma być 1.0
    expect(indicator.value, 1.0);
    // Sprawdź kolor: powyżej celu -> czerwony
    expect(indicator.color, Colors.red);
  });

  testWidgets('Should show green color exactly when the goal is achieved', (tester) async {
    await tester.pumpWidget(createTestWidget(calories: 2000, goal: 2000));

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );

    expect(indicator.value, 1.0);
    // calories > goal ? Colors.red : Colors.green -> dla równych ma być zielony
    expect(indicator.color, Colors.green);
  });

  testWidgets('Should handle zero calories', (tester) async {
    await tester.pumpWidget(createTestWidget(calories: 0, goal: 2000));

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );

    expect(indicator.value, 0.0);
    expect(indicator.color, Colors.green);
  });
}