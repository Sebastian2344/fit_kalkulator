import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/source/calculator_source.dart';

class CalorieRepository {
  final CalculatorSource _source;

  const CalorieRepository(this._source);

  CalorieResult getDailyCalories(UserStats stats) {
    // Tutaj repozytorium mogłoby np. dodatkowo zapisać wynik w lokalnej bazie
    return _source.calculateBmrAndTdee(stats);
  }
}