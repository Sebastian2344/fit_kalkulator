import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/model/product_model.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/repo/repo_barcode.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/source/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBarcodeApiService extends Mock implements BarcodeApiService {}

void main() {
  group('RepoBarcode Tests', () {
    late RepoBarcode repository;
    late MockBarcodeApiService mockApiService;

    setUp(() {
      mockApiService = MockBarcodeApiService();
      repository = RepoBarcode(mockApiService);
    });

    test('fetchProductByBarcode returns product when status is 1', () async {
      final mockProductModel = ProductModel(name: "Test Product", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1, status: 1);
      final expectedProduct = Product(name: "Test Product", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1);

      when(() => mockApiService.fetchProductByBarcode("123"))
          .thenAnswer((_) async => mockProductModel);

      final result = await repository.fetchProductByBarcode("123");

      expect(result, equals(expectedProduct));
    });

    test('fetchProductByBarcode throws exception when status is 0', () async {
      when(() => mockApiService.fetchProductByBarcode("123")).thenAnswer((_) async => throw Exception("Product not found"));
      expect(() => repository.fetchProductByBarcode("123"), throwsException);
    });
  });
}