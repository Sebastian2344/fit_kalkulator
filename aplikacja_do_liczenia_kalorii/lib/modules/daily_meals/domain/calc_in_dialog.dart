import 'package:aplikacja_do_liczenia_kalorii/core/model/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class CalcInDialog extends Notifier<CalcData> {
  @override
  CalcData build() {
    return CalcData(
      product: Product(
        name: "",
        kcalPer100g: 0,
        carbsPer100g: 0.0,
        proteinPer100g: 0.0,
        fatPer100g: 0.0,
      ),
      calories: 0,
      carbs: 0.0,
      protein: 0.0,
      fat: 0.0,
    );
  }


  void recalculate(Product product, TextEditingController weightController) {
    final weight = int.tryParse(weightController.text) ?? 0;

      final ratio = weight / 100.0;
      final calcCalories = (ratio * product.kcalPer100g).round();
      final calcProtein = ratio * product.proteinPer100g;
      final calcFat = ratio * product.fatPer100g;
      final calcCarbs = ratio * product.carbsPer100g;

      state = state.copyWith(
        product: product,
        calories: calcCalories,
        protein: calcProtein,
        fat: calcFat,
        carbs: calcCarbs,
      );
  }

  void reset() {
    state = CalcData(
      product: Product(
        name: "",
        kcalPer100g: 0,
        carbsPer100g: 0.0,
        proteinPer100g: 0.0,
        fatPer100g: 0.0,
      ),
      calories: 0,
      carbs: 0.0,
      protein: 0.0,
      fat: 0.0,
    );
  }

}

final calcInDialogProvider = NotifierProvider<CalcInDialog, CalcData>(CalcInDialog.new); 