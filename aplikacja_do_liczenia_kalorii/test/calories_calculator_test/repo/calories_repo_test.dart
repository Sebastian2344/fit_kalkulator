import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/repo/calories_repo.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/source/calculator_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCalculatorSource extends Mock implements CalculatorSource {}

void main() {
  group('Calorie Calculation Tests', () {
    late MockCalculatorSource mockSource;
    late CalorieRepository repo;

    setUp(() {
      mockSource = MockCalculatorSource();
      repo = CalorieRepository(mockSource);
    });
    test('CalorieRepository calls source and returns results', () {
      
      final stats = UserStats(
        weight: 70, height: 170, age: 30, 
        gender: Gender.female, activityLevel: ActivityLevel.light
      );
      final expectedResult = CalorieResult(bmr: 1400, tdee: 1700);

      when(() => mockSource.calculateBmrAndTdee(stats)).thenReturn(expectedResult);

      final result = repo.getDailyCalories(stats);

      expect(result, expectedResult);
      verify(() => mockSource.calculateBmrAndTdee(stats)).called(1);
    });
  });
}