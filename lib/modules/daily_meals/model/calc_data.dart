import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:equatable/equatable.dart';

class CalcData extends Equatable {
  final Product product;
  final int calories;
  final double carbs;
  final double protein;
  final double fat;

  const CalcData({
    required this.product,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  CalcData copyWith({
    Product? product,
    int? calories,
    double? carbs,
    double? protein,
    double? fat,
  }) {
    return CalcData(
      product: product ?? this.product,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
    );
  }

  @override
  List<Object?> get props => [product, calories, carbs, protein, fat];
}