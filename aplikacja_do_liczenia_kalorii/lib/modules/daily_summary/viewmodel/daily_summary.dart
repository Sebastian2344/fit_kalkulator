import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'daily_summary.g.dart';

class DailySummary {
  final int calories;
  final double protein;
  final double fat;
  final double carbs;
  const DailySummary(this.calories, this.protein, this.fat, this.carbs);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySummary &&
          calories == other.calories &&
          protein == other.protein &&
          fat == other.fat &&
          carbs == other.carbs;

  @override
  int get hashCode => Object.hash(calories, protein, fat, carbs);
}

@riverpod
DailySummary dailySummary(Ref ref) {
  final meals = ref.watch(dailyMealsProvider);
  return meals.fold(
    DailySummary(0, 0, 0, 0),
    (prev, meal) => DailySummary(
      prev.calories + meal.calories,
      prev.protein + meal.protein,
      prev.fat + meal.fat,
      prev.carbs + meal.carbs,
    ),
  );
}
