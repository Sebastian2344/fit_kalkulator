import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BarcodeApiService {
  const BarcodeApiService(this.httpClient);
  final http.Client httpClient;
  Future<ProductModel?> fetchProductByBarcode(String barcode) async {
    // Używamy darmowego API OpenFoodFacts
    final url = Uri.parse(
      'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
    );

    try {
      final response = await httpClient.get(
        url,
        headers: {'User-Agent': 'FitKalkulatorApp - Android - Version 1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
         if (data['status'] == 0 || data['product'] == null) {
          return null; 
        }
        return ProductModel.fromJson(data);
      }
    } catch (e) {
      throw Exception("Błąd pobierania produktu: $e");
    }
    return null;
  }
}
