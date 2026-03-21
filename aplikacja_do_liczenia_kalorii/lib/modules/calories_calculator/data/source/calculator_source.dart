import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/model/calories_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorSource {
  CalorieResult calculateBmrAndTdee(UserStats stats) {
    // Wzór Mifflina-St Jeora
    double base = (10 * stats.weight) + (6.25 * stats.height) - (5 * stats.age);
    double bmr = stats.gender == Gender.male ? base + 5 : base - 161;
    double tdee = bmr * stats.activityLevel.multiplier;

    return CalorieResult(bmr: bmr, tdee: tdee);
  }
}

final calculatorSourceProvider = Provider<CalculatorSource>((ref) {
  return CalculatorSource();
});