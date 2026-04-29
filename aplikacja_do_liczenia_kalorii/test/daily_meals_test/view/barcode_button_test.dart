import 'dart:async';

import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/view/barcode_screen.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/viewmodel/barcode_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/barcode_button.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeBarcodeNotifier extends BarcodeProvider {
  Product? productToReturn; // To ustawimy w teście, żeby kontrolować wynik

  @override
  FutureOr<Product?> build() => null; // Stan początkowy

  @override
  Future<void> scanBarcode(String code) async {
    state = const AsyncLoading(); // Zmiana stanu na ładowanie (dla SnackBar/Koloru)
    
    // Symulujemy krótkie opóźnienie, aby test "poczuł" asynchroniczność
    await Future.delayed(Duration.zero); 

    productToReturn = Product(name: 'Banan', kcalPer100g: 100, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1);
    state = AsyncData(productToReturn);
  }
}

// Fake dla Notifiera Kalkulatora
class FakeCalcNotifier extends CalcInDialog {
  Product? capturedProduct;
  bool recalculateCalled = false;

  @override
  CalcData build() => CalcData(product: Product(name: '', kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1), calories: 1, carbs: 1, protein: 1, fat: 1);

  @override
  void recalculate(Product product, TextEditingController controller) {
    recalculateCalled = true;
    capturedProduct = product;
  }
}

void main() {
  late FakeBarcodeNotifier fakeBarcode;
  late FakeCalcNotifier fakeCalc;
  late TextEditingController weightController;

  setUp(() {
    fakeBarcode = FakeBarcodeNotifier();
    fakeCalc = FakeCalcNotifier();
    weightController = TextEditingController();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        barcodeProviderProvider.overrideWith(() => fakeBarcode),
        calcInDialogProvider.overrideWith(() => fakeCalc),
      ],
      child: MaterialApp(
        // Ważne: dodajemy trasę dla skanera, jeśli Twój kod go szuka
        home: Scaffold(
          body: BarcodeButton(weightController: weightController),
        ),
      ),
    );
  }

  testWidgets('Kliknięcie otwiera skaner i po sukcesie wywołuje recalculate', (tester) async {
    // Przygotowanie danych
    final testProduct = Product(name: 'Banan', kcalPer100g: 100, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1);
    
    await tester.pumpWidget(createTestWidget());
    fakeBarcode.productToReturn = testProduct;

    // 1. Klikamy przycisk skanowania
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // 2. Sprawdzamy czy skaner się otworzył
    expect(find.byType(BarcodeScannerScreen), findsOneWidget);

    // 3. Symulujemy powrót ze skanera
    Navigator.of(tester.element(find.byType(BarcodeScannerScreen))).pop('12345');
    
    // 4. Proces szukania - najpierw pump(), żeby zacząć asynchroniczną metodę
    await tester.pump(); 
    expect(find.text('Szukam produktu...'), findsOneWidget);

    // 5. Czekamy na zakończenie scanBarcode (Future.delayed w Fake'u)
    await tester.pumpAndSettle();

    // 6. Weryfikacja efektów
    expect(fakeCalc.recalculateCalled, isTrue);
    expect(fakeCalc.capturedProduct?.name, 'Banan');
  });

  testWidgets('Pokazuje komunikat błędu, gdy produkt nie zostanie znaleziony', (tester) async {
    fakeBarcode.productToReturn = null; // Nic nie znaleziono

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    Navigator.of(tester.element(find.byType(BarcodeScannerScreen))).pop('000');
    await tester.pumpAndSettle();

    expect(find.text('Nie znaleziono produktu w bazie.'), findsOneWidget);
    expect(fakeCalc.recalculateCalled, isFalse);
  });

  testWidgets('Kolor ikony zmienia się w zależności od stanu', (tester) async {
    await tester.pumpWidget(createTestWidget());

    // Stan początkowy (null)
    Icon icon = tester.widget(find.byIcon(Icons.qr_code_scanner));
    expect(icon.color, Colors.limeAccent);

    fakeBarcode.scanBarcode('123');
    await tester.pumpAndSettle();
    
    icon = tester.widget(find.byIcon(Icons.qr_code_scanner));
    expect(icon.color, Colors.lightGreenAccent);
  });
}