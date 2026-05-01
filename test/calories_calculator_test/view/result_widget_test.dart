import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/view/result_widget.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCalculatorController extends CalculatorController {
  final CalorieResult? initialState;

  FakeCalculatorController(this.initialState);

  @override
  CalorieResult? build() => initialState;
}

void main() {
  // Funkcja pomocnicza budująca widget w srodowisku Riverpod
  Widget createTestWidget(CalorieResult? initialState) {
    return ProviderScope(
      overrides: [
        // Podmieniamy oryginalny provider naszym, testowym
        // (Jeśli używasz generatora Riverpod, to upewnij się,
        // że podmieniasz wygenerowany 'calculatorControllerProvider')
        calculatorControllerProvider.overrideWith(
          () => FakeCalculatorController(initialState),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: ResultWidget())),
    );
  }

  group('tests', () {
    testWidgets(
      'should not display results card when state is null',
      (tester) async {
        // Odpalamy widget z pusytm stanem
        await tester.pumpWidget(createTestWidget(null));

        // Karta oraz słowo "Wyniki:" nie powinny w ogóle istnieć w drzewie widgetów
        expect(find.byType(Card), findsNothing);
        expect(find.text('Wyniki:'), findsNothing);
      },
    );

    testWidgets(
      'should display results and round decimal values to whole numbers',
      (tester) async {
        // Przygotowujemy stan z liczbami po przecinku, by sprawdzić toStringAsFixed(0)
        final state = CalorieResult(
          bmr: 1850.4, // powino zaokrąglić w dół do 1850
          tdee: 2499.6, // powinno zaokrąglić w górę do 2500
        );

        await tester.pumpWidget(createTestWidget(state));

        // Sprawdzamy obecność karty
        expect(find.byType(Card), findsOneWidget);

        // Sprawdzamy nagłówek
        expect(find.text('Wyniki:'), findsOneWidget);

        // Sprawdzamy czy poprawnie sformatowało teksty z zaokrąglaniem
        expect(find.text('BMR: 1850 kcal'), findsOneWidget);
        expect(find.text('TDEE: 2500 kcal'), findsOneWidget);
      },
    );

    testWidgets(
      'should check TDEE styling (whether it is blue and bold)',
      (tester) async {
        final state = CalorieResult(bmr: 1500, tdee: 2000);
        await tester.pumpWidget(createTestWidget(state));

        final finder = find.text('TDEE: 2000 kcal');
        expect(finder, findsOneWidget);

        // Wyciągamy widget Text
        final textWidget = tester.widget<Text>(finder);

        // Sprawdzamy style czcionki
        expect(textWidget.style?.fontWeight, FontWeight.bold);
        expect(textWidget.style?.color, Colors.blue);
        expect(textWidget.style?.fontSize, 20);
      },
    );
  });
}
