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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
  // Pobieramy status i mapę produktu (jeśli nie ma, dajemy pustą mapę)
  final int status = json['status'] ?? 0;
  final productData = json['product'] ?? {};
  final nutriments = productData['nutriments'] ?? {};

  // Funkcja pomocnicza do bezpiecznego konwertowania na double
  double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0;
  }

  // Funkcja pomocnicza do bezpiecznego konwertowania na int
  int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return 0;
  }

  return ProductModel(
    name: (productData['product_name'] ?? "Nieznany produkt").toString(),
    kcalPer100g: toInt(nutriments['energy-kcal_100g']),
    proteinPer100g: toDouble(nutriments['proteins_100g']),
    fatPer100g: toDouble(nutriments['fat_100g']),
    carbsPer100g: toDouble(nutriments['carbohydrates_100g']),
    status: status,
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