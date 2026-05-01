import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/source/calculator_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late CalculatorSource source;

  setUp(() {
      source = CalculatorSource();
  });
  test('CalculatorSource calculates BMR and TDEE correctly for male', () {
      final stats = UserStats(
        weight: 80,
        height: 180,
        age: 25,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderate, // multiplier np. 1.55
      );

      final result = source.calculateBmrAndTdee(stats);

      // (10*80) + (6.25*180) - (5*25) + 5 = 800 + 1125 - 125 + 5 = 1805
      expect(result.bmr, 1805.0);
      expect(result.tdee, 1805.0 * 1.55);
    });
}