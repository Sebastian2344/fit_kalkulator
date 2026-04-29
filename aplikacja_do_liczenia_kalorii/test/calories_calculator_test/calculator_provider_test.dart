import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/calculator_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late ProviderContainer container;
  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('CalculatorController should return null initially', () {
    expect(container.read(calculatorControllerProvider), null);
  });

  test('CalculatorController should calculate calories correctly', () {
    // Przygotuj dane wejściowe
    final stats = UserStats(
      age: 30,
      weight: 70,
      height: 175,
      gender: Gender.male,
      activityLevel: ActivityLevel.active,  
    );
    // Wywołaj metodę calculate
    container.read(calculatorControllerProvider.notifier).calculate(stats);
    // Sprawdź, czy wynik jest poprawny (przykładowa wartość, dostosuj do swojej logiki)
    final result = container.read(calculatorControllerProvider);
    expect(result, isNotNull);
    expect(result!.bmr, greaterThan(0));
    expect(result.tdee, greaterThan(0)); // Zakładamy, że wynik powinien być większy niż 0
  });
}