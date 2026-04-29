import 'package:aplikacja_do_liczenia_kalorii/core/di/providers.dart';
import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/repo/repo_barcode.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/viewmodel/barcode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepoBarcode extends Mock implements RepoBarcode {}

void main(){
  late ProviderContainer container;
  setUp(() {
    container = ProviderContainer(
      overrides: [
        repoBarcodeProvider.overrideWithValue(MockRepoBarcode())
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // Dodaj testy dla providera tutaj
  test('return initial state', (){
    final barcode = container.read(barcodeProviderProvider);
    expect(barcode.value, null); // Początkowo brak produktu
  });

  test('should update barcode when scanBarcode is called', () async {
    final mockRepo = container.read(repoBarcodeProvider);
    final newBarcode = '123456789012';
    final product = Product(name: 'Test Product',kcalPer100g: 10,fatPer100g: 10,carbsPer100g: 10,proteinPer100g: 10);

    when(() => mockRepo.fetchProductByBarcode(newBarcode)).thenAnswer((_) => Future.value(product));

    final result = container.read(barcodeProviderProvider);
    expect(result, AsyncData<Product?>(null)); // Początkowo brak produktu

    await container.read(barcodeProviderProvider.notifier).scanBarcode(newBarcode);
    
    final result2 = container.read(barcodeProviderProvider);
    expect(result2, AsyncData<Product?>(product));
  });

  test('should handle error when scanBarcode fails', () async {
    final mockRepo = container.read(repoBarcodeProvider);
    final newBarcode = '123456789012';
    final errorMessage = 'Failed to fetch product';

    when(() => mockRepo.fetchProductByBarcode(newBarcode)).thenThrow(Exception(errorMessage));

    final result = container.read(barcodeProviderProvider);
    expect(result, AsyncData<Product?>(null)); // Początkowo brak produktu

    await container.read(barcodeProviderProvider.notifier).scanBarcode(newBarcode);

    final result2 = container.read(barcodeProviderProvider);
    expect(result2.hasError, true);
    expect(result2.error.toString(), contains(errorMessage));
  });

}