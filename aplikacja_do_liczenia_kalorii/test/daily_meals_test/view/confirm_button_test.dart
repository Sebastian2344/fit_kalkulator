import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/confirm_button.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';


class FakeDailyMeals extends DailyMeals {
  bool addMealCalled = false;
  @override
  List<Meal> build() => [];
  
  @override
  void addMeal(Meal meal) {
    addMealCalled = true;
  }
}

class FakeCalcNotifier extends CalcInDialog {
  bool resetCalled = false;
  @override
  CalcData build() => CalcData(
    product: Product(name: "Kurczak", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1), // Dane testowe
    calories: 100, protein: 20, fat: 2, carbs: 0
  );

  @override
  void reset() {
    resetCalled = true;
  }
}

void main() {
  late FakeDailyMeals fakeDailyMeals;
  late FakeCalcNotifier fakeCalc;
  late TextEditingController controller;

  setUp(() {
    fakeDailyMeals = FakeDailyMeals();
    fakeCalc = FakeCalcNotifier();
    controller = TextEditingController();
  });

  Widget createTestableWidget() {
    return ProviderScope(
      overrides: [
        dailyMealsProvider.overrideWith(() => fakeDailyMeals),
        calcInDialogProvider.overrideWith(() => fakeCalc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ConfirmButton(weightController: controller),
        ),
      ),
    );
  }

  testWidgets('Powinien dodać posiłek i zresetować kalkulator, gdy waga > 0', (tester) async {
    await tester.pumpWidget(createTestableWidget());

    // 1. Wpisujemy wagę do kontrolera
    controller.text = "150";
    
    // 2. Klikamy przycisk
    await tester.tap(find.text("Zatwierdź"));
    await tester.pumpAndSettle();

    // 3. Sprawdzamy czy wywołano odpowiednie metody
    expect(fakeDailyMeals.addMealCalled, isTrue);
    expect(fakeCalc.resetCalled, isTrue);
  });

  testWidgets('', (tester) async {
    await tester.pumpWidget(createTestableWidget());

    // 1. Wpisujemy "0"
    controller.text = "0";
    
    // 2. Klikamy przycisk
    await tester.tap(find.text("Zatwierdź"));
    await tester.pump(); // Bez settle, bo nie spodziewamy się nawigacji

    // 3. Sprawdzamy, że metody NIE zostały wywołane
    expect(fakeDailyMeals.addMealCalled, isFalse);
    expect(fakeCalc.resetCalled, isFalse);
  });
}