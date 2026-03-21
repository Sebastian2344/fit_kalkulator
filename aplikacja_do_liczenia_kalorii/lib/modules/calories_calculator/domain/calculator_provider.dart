import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/repo/calories_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorState extends Equatable {
  final CalorieResult? result;
  const CalculatorState({this.result});

  CalculatorState copyWith({CalorieResult? result}) {
    return CalculatorState(result: result ?? this.result);
  }

  @override
  List<Object?> get props => [result];
}

class CalculatorController extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    return CalculatorState(result: null);
  }

  void calculate(UserStats stats) {
    // Odczytujemy repozytorium z domeny
    final repo = ref.read(calorieRepositoryProvider);

    // Obliczamy i aktualizujemy stan ekranu
    final result = repo.getDailyCalories(stats);
    state = state.copyWith(result: result);
  }

  void reset() {
    state = state.copyWith(result: null);
  }
}

// Provider kontrolera ekranu
final calculatorControllerProvider =
    NotifierProvider<CalculatorController, CalculatorState>(() {
      return CalculatorController();
    });
