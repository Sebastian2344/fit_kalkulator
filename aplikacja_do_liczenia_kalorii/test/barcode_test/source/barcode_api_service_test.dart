import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/source/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mocktail/mocktail.dart';
class MockClient extends Mock implements http.Client {}

void main() {
  late BarcodeApiService apiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    apiService = BarcodeApiService(mockClient);
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  test('Zwraca ProductModel gdy API odpowie sukcesem (status 1)', () async {
    // Przygotuj sztuczną odpowiedź JSON
    final mockResponse = {
      "status": 1,
      "product": {
        "product_name": "Testowy Produkt",
        "nutriments": {
          "energy-kcal_100g": 100,
          "proteins_100g": 10.0,
          "fat_100g": 5.0,
          "carbohydrates_100g": 20.0
        }
      }
    };

    // Ustaw zachowanie mocka
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(json.encode(mockResponse), 200));

    // Wykonaj test
    final result = await apiService.fetchProductByBarcode('12345');

    // Sprawdź wyniki
    expect(result, isNotNull);
    expect(result!.name, "Testowy Produkt");
    expect(result.kcalPer100g, 100);
  });

  test('Zwraca null gdy produkt nie istnieje w bazie (status 0)', () async {
    final mockResponse = {"status": 0, "status_verbose": "product not found"};

    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(json.encode(mockResponse), 200));

    final result = await apiService.fetchProductByBarcode('00000');

    expect(result, isNull);
  });

  test('Rzuca wyjątek przy błędzie sieciowym', () async {
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenThrow(Exception("No internet"));

    expect(() => apiService.fetchProductByBarcode('123'), throwsException);
  });
}