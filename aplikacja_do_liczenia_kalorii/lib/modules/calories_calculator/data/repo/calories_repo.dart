import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/source/calculator_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalorieRepository {
  final CalculatorSource _source;

  CalorieRepository(this._source);

  CalorieResult getDailyCalories(UserStats stats) {
    // Tutaj repozytorium mogłoby np. dodatkowo zapisać wynik w lokalnej bazie
    return _source.calculateBmrAndTdee(stats);
  }
}

final calorieRepositoryProvider = Provider<CalorieRepository>((ref) {
  final source = ref.watch(calculatorSourceProvider);
  return CalorieRepository(source);
});