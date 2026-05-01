import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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