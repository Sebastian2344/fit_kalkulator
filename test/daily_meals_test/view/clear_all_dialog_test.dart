import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/clear_all_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDailyMeals extends DailyMeals {
  bool clearMealsCalled = false;

  @override
  List<Meal> build() => []; // Zwróć pusty stan początkowy

  @override
  void clearMeals() {
    clearMealsCalled = true; // Zamiast verify(), używamy flagi
  }
}

void main() {
  late FakeDailyMeals fakeDailyMeals;

  setUp(() {
    fakeDailyMeals = FakeDailyMeals();
  });

  // Pomocnicza funkcja do budowania widgetu w testach
  Widget createTestableWidget() {
    return ProviderScope(
      overrides: [
        // Nadpisujemy prawdziwy provider naszym mockiem
        dailyMealsProvider.overrideWith(() => fakeDailyMeals),
      ],
      child: const MaterialApp(home: Scaffold(body: ClearAllDialog())),
    );
  }

  group('tasks', () {
    testWidgets('Powinien wyświetlać poprawne teksty w dialogu', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.text("Wyczyść dziennik?"), findsOneWidget);
      expect(
        find.text("Czy na pewno chcesz usunąć wszystkie posiłki z dziennika?"),
        findsOneWidget,
      );
      expect(find.text("Anuluj"), findsOneWidget);
      expect(find.text("Wyczyść"), findsOneWidget);
    });

    testWidgets(
      'Kliknięcie Anuluj powinno zamknąć dialog bez wywoływania clearMeals',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        await tester.tap(find.text("Anuluj"));
        await tester
            .pumpAndSettle(); // Czekamy na zakończenie animacji zamykania

        // Sprawdzamy czy dialog zniknął
        expect(find.byType(ClearAllDialog), findsNothing);

        // Sprawdzamy czy metoda NIE została wywołana
        expect(fakeDailyMeals.clearMealsCalled, isFalse);
      },
    );

    testWidgets(
      'Kliknięcie Wyczyść powinno wywołać clearMeals i zamknąć dialog',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        await tester.tap(find.text("Wyczyść"));
        await tester.pumpAndSettle();

        // Sprawdzamy czy metoda została wywołana dokładnie raz
        expect(fakeDailyMeals.clearMealsCalled, isTrue);

        // Sprawdzamy czy dialog został zamknięty
        expect(find.byType(ClearAllDialog), findsNothing);
      },
    );
  });
}
