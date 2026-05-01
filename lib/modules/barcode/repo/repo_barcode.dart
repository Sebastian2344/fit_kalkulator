import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/source/api_service.dart';
import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:flutter/material.dart';

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

    if (data.status == 1) {
      return data.toProduct();
    } else {
      throw Exception("Produkt o kodzie $barcode nie został znaleziony.");
    }
  }
}
