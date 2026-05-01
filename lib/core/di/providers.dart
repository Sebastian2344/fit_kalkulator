import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/repo/repo_barcode.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/source/api_service.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/repo/calories_repo.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/source/calculator_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

Provider<RepoBarcode> repoBarcodeProvider = Provider((ref) {
  return RepoBarcode(BarcodeApiService(Client()));
});

final calculatorSourceProvider = Provider<CalculatorSource>((ref) {
  return CalculatorSource();
});

final calorieRepositoryProvider = Provider<CalorieRepository>((ref) {
  final source = ref.watch(calculatorSourceProvider);
  return CalorieRepository(source);
});