import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/data/source/api_service.dart';
import 'package:aplikacja_do_liczenia_kalorii/core/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class RepoBarcode {
  final BarcodeApiService apiService;
  const RepoBarcode(this.apiService);
  Future<Product?> fetchProductByBarcode(String barcode) async {
    // Używamy darmowego API OpenFoodFacts
    final data = await apiService.fetchProductByBarcode(barcode);
    
    if (data == null) {
      debugPrint("Brak danych dla kodu $barcode");
      return null;
    }

    if (data['status'] == 1) {
        final productData = data['product'];
        final nutriments = productData['nutriments'];

        // Pobieramy dane (zabezpieczamy się przed nullami, jeśli brakuje danych)
        return Product(
          name: productData['product_name'] ?? 'Nieznany produkt',
          kcalPer100g: (nutriments['energy-kcal_100g'] ?? 0).toInt(),
          proteinPer100g: (nutriments['proteins_100g'] ?? 0).toDouble(),
          fatPer100g: (nutriments['fat_100g'] ?? 0).toDouble(),
          carbsPer100g: (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
        );
      } else {
        throw Exception("Produkt o kodzie $barcode nie został znaleziony.");
      }
  }
}

Provider<RepoBarcode> repoBarcodeProvider = Provider((ref) {
  return RepoBarcode(BarcodeApiService(Client()));
});