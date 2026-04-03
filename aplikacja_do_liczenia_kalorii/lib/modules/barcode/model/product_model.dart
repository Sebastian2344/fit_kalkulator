import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';

class ProductModel {
  final String name;
  final int kcalPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;
  final int status;

  const ProductModel({
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    required this.status,
  });

  factory ProductModel.fromJson(dynamic productData, dynamic nutriments,dynamic status) {
    return ProductModel(
      name: (productData['product_name'] ?? "Nieznany produkt") as String,
      kcalPer100g: (nutriments['energy-kcal_100g'] ?? 0) as int,
      proteinPer100g: (nutriments['proteins_100g'] ?? 0.0) as double,
      fatPer100g: (nutriments['fat_100g'] ?? 0.0) as double,
      carbsPer100g: (nutriments['carbohydrates_100g'] ?? 0.0) as double,
      status: (status['status'] ?? 0) as int,
    );
  }

  Product toProduct() {
    return Product(
      name: name,
      kcalPer100g: kcalPer100g,
      proteinPer100g: proteinPer100g,
      fatPer100g: fatPer100g,
      carbsPer100g: carbsPer100g,
    );
  }
}