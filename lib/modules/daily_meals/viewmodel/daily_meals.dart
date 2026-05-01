import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_meals.g.dart';
// --- Zarządzanie Posiłkami (CRUD w Hive) ---
@riverpod
Box<Meal> mealsBox(Ref ref) {
  return Hive.box<Meal>('meals');
}

@riverpod
class DailyMeals extends _$DailyMeals {
  
  @override
  List<Meal> build() {
    // 2. Pobierasz box przez ref.watch
    final box = ref.watch(mealsBoxProvider);
    
    final meals = box.values.toList();
    meals.sort((a, b) => b.date.compareTo(a.date));
    return meals;
  }

  void addMeal(Meal meal) {
    final box = ref.read(mealsBoxProvider); // Pobierasz box
    box.put(meal.id, meal);
    state = [meal, ...state];
  }

  void removeMeal(String id) {
    final box = ref.read(mealsBoxProvider);
    box.delete(id);
    state = state.where((m) => m.id != id).toList();
  }

  void clearMeals() {
    final box = ref.read(mealsBoxProvider);
    box.clear();
    state = [];
  }
}