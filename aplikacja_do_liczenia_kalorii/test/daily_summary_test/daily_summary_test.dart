import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_summary/viewmodel/daily_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('DailySummary should correctly sum values (without Hive)', () {

    final testMeals = [
      Meal(
        name: 'Śniadanie',
        calories: 500,
        protein: 20.0,
        fat: 10.0,
        carbs: 50.0,
        weight: 100,
        date: DateTime.now(),
      ),
      Meal(
        name: 'Obiad',
        calories: 700,
        protein: 30.0,
        fat: 20.0,
        carbs: 60.0,
        weight: 200,
        date: DateTime.now(),
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        dailyMealsProvider.overrideWithValue(testMeals),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(dailySummaryProvider);

    expect(summary.calories, 1200); // 500 + 700
    expect(summary.protein, 50.0);  // 20 + 30
    expect(summary.fat, 30.0);      // 10 + 20
    expect(summary.carbs, 110.0);   // 50 + 60
  });

  test('DailySummary should return zeros for empty list', () {
    final container = ProviderContainer(
      overrides: [
        dailyMealsProvider.overrideWithValue([]), // Pusta lista
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(dailySummaryProvider);

    expect(summary.calories, 0);
    expect(summary.protein, 0.0);
    expect(summary, const DailySummary(0, 0, 0, 0));
  });
}