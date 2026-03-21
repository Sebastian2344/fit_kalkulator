import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/data/meal.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_meals.g.dart';
// --- Zarządzanie Posiłkami (CRUD w Hive) ---
@riverpod
class DailyMeals extends _$DailyMeals {
  late Box<Meal> _mealsBox;

  @override
  List<Meal> build() {
    _mealsBox = Hive.box<Meal>('meals');
    // Zwracamy listę posiłków (można dodać filtrowanie po dacie tutaj)
    // Na potrzeby demo pobieramy wszystko i sortujemy od najnowszych
    final meals = _mealsBox.values.toList();
    meals.sort((a, b) => b.date.compareTo(a.date));
    return meals;
  }

  void addMeal(Meal meal) {
    _mealsBox.put(meal.id, meal);
    // Odśwież stan
    state = [meal, ...state];
  }

  void removeMeal(String id) {
    _mealsBox.delete(id);
    state = state.where((m) => m.id != id).toList();
  }
}