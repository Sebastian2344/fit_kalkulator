import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/view/calories_summary.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/viewmodel/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Funkcja pomocnicza aby kod był czysty
  Widget createTestWidget(int calories) {
    return ProviderScope(
      overrides: [
        // Nadpisujemy wygenerowany provider. 
        // Zakładam że dailySummaryProvider zwraca obiekt typu DailySummary
        dailySummaryProvider.overrideWith((ref) => DailySummary(calories, 0, 0, 0)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: CaloriesSummary(),
        ),
      ),
    );
  }

  testWidgets('Should display "Zjedzone: 0 kcal" when no calories are consumed', (tester) async {
    await tester.pumpWidget(createTestWidget(0));

    expect(find.text('Zjedzone: 0 kcal'), findsOneWidget);
  });

  testWidgets('Should display the correct number of calories after consuming a meal', (tester) async {
    await tester.pumpWidget(createTestWidget(1850));

    // Sprawdzamy czy tekst dynamicznie się podmienia
    expect(find.text('Zjedzone: 1850 kcal'), findsOneWidget);
  });

  testWidgets('Should have a bold font style', (tester) async {
    await tester.pumpWidget(createTestWidget(500));

    // Wyciągamy widget Text żeby sprawdzić jego styl
    final textWidget = tester.widget<Text>(find.byType(Text));
    
    expect(textWidget.style?.fontWeight, FontWeight.bold);
  });
}