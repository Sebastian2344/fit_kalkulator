import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/selected_product_list.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDailyMeals extends DailyMeals {
  bool addMealCalled = false;
  String? lastRemovedId;

  @override
  List<Meal> build() => [];

  // Pozwalamy na ręczne ustawienie stanu w testach
  void setMeals(List<Meal> meals) => state = meals;

  @override
  void removeMeal(String id) {
    lastRemovedId = id;
    state = state.where((m) => m.id != id).toList();
  }

  @override
  void addMeal(Meal meal) {
    addMealCalled = true;
    state = [...state, meal];
  }
}

void main() {
  late FakeDailyMeals fakeNotifier;

  setUp(() {
    fakeNotifier = FakeDailyMeals();
  });

  Widget createTestableWidget() {
    return ProviderScope(
      overrides: [dailyMealsProvider.overrideWith(() => fakeNotifier)],
      child: const MaterialApp(
        home: Scaffold(body: Column(children: [SelectedProductList()])),
      ),
    );
  }

  group('SelectedProductList Widget Tests', () {
    testWidgets('Powinien wyświetlić komunikat o braku posiłków', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      fakeNotifier.setMeals([]); // Pusta lista
     
      expect(find.text("Brak posiłków. Dodaj coś!"), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });

    testWidgets('Powinien wyświetlić listę posiłków', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      
      fakeNotifier.setMeals([
        Meal(
          id: '1',
          name: 'Kurczak',
          weight: 100,
          calories: 150,
          protein: 20,
          fat: 5,
          carbs: 1,
          date: DateTime.now(),
        ),
        Meal(
          id: '2',
          name: 'Ryż',
          weight: 50,
          calories: 100,
          protein: 2,
          fat: 0,
          carbs: 20,
          date: DateTime.now(),
        ),
      ]);

      await tester.pumpAndSettle(); // Czekamy na aktualizację UI

      expect(find.text('Kurczak'), findsOneWidget);
      expect(find.text('Ryż'), findsOneWidget);
      expect(find.text('150 kcal'), findsOneWidget);
      expect(find.text('100g'), findsOneWidget);
    });

    testWidgets('Usunięcie poprzez przesunięcie (Dismissible)', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      
      fakeNotifier.setMeals([
        Meal(
          id: '1',
          name: 'Do usunięcia',
          weight: 100,
          calories: 100,
          protein: 10,
          fat: 1,
          carbs: 1,
          date: DateTime.now(),
        ),
      ]);
      
      await tester.pumpAndSettle(); // Czekamy na animację znikania
      // Wykonujemy gest przesunięcia od prawej do lewej
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle(); // Czekamy na animację znikania

      // Sprawdzamy czy notifier otrzymał id
      expect(fakeNotifier.lastRemovedId, '1');
      // Sprawdzamy czy pokazał się SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Usunięto: Do usunięcia'), findsOneWidget);
    });

    testWidgets(
      'Kliknięcie ikony kosza otwiera dialog i usuwa po potwierdzeniu',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());
        fakeNotifier.setMeals([
          Meal(
            id: '1',
            name: 'Kurczak',
            weight: 100,
            calories: 100,
            protein: 10,
            fat: 1,
            carbs: 1,
            date: DateTime.now(),
          ),
        ]);
        await tester.pumpAndSettle();
        // 1. Klikamy w ikonę kosza (IconButton)
        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle(); // Czekamy na otwarcie dialogu

        // 2. Sprawdzamy czy dialog się pojawił
        expect(find.text("Usunąć posiłek?"), findsOneWidget);

        // 3. Klikamy "Usuń" w dialogu
        // Używamy find.descendant, żeby kliknąć w przycisk w dialogu, a nie pod spodem
        final confirmButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text("Usuń"),
        );
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();

        // 4. Sprawdzamy czy usunięto
        expect(fakeNotifier.lastRemovedId, '1');
        expect(find.byType(AlertDialog), findsNothing);
      },
    );

    testWidgets('Cofnięcie usunięcia ze SnackBara', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      fakeNotifier.setMeals([
        Meal(
          id: '1',
          name: 'Test',
          weight: 100,
          calories: 100,
          protein: 1,
          fat: 1,
          carbs: 1,
          date: DateTime.now(),
        ),
      ]);
        await tester.pumpAndSettle();

      // Przesuwamy, żeby usunąć i wywołać SnackBar
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Klikamy "Cofnij" na SnackBarze
      await tester.tap(find.text('Cofnij'));
      await tester.pumpAndSettle();

      // Sprawdzamy czy wywołano addMeal
      expect(fakeNotifier.addMealCalled, isTrue);
    });
  });
}
