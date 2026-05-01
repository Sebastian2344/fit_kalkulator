import 'package:aplikacja_do_liczenia_kalorii/core/di/providers.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorController extends Notifier<CalorieResult?> {
  @override
  CalorieResult? build() {
    return null;
  }

  void calculate(UserStats stats) {
    // Odczytujemy repozytorium z domeny
    final repo = ref.read(calorieRepositoryProvider);

    // Obliczamy i aktualizujemy stan ekranu
    final result = repo.getDailyCalories(stats);
    state = result;
  }

  void reset() {
    state = null;
  }
}

// Provider kontrolera ekranu
final calculatorControllerProvider =
    NotifierProvider<CalculatorController, CalorieResult?>(() {
      return CalculatorController();
    });
