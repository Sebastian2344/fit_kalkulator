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
    if(code == "000"){
      productToReturn = null;
      state = const AsyncData(null);
      return;
    }
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
        home: Scaffold(
          body: BarcodeButton(weightController: weightController),
        ),
      ),
    );
  }

  testWidgets('Kliknięcie otwiera skaner i po sukcesie wywołuje recalculate', (tester) async {
    
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.byType(BarcodeScannerScreen), findsOneWidget);

    Navigator.of(tester.element(find.byType(BarcodeScannerScreen))).pop('12345');

    await tester.pumpAndSettle();

    expect(fakeCalc.recalculateCalled, isTrue);
    expect(fakeCalc.capturedProduct?.name, 'Banan');
  });

  testWidgets('Pokazuje komunikat błędu, gdy produkt nie zostanie znaleziony', (tester) async {
   
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.byType(BarcodeScannerScreen), findsOneWidget);
    Navigator.of(tester.element(find.byType(BarcodeScannerScreen))).pop('000');
    await tester.pumpAndSettle();

    expect(find.byType(BarcodeScannerScreen), findsNothing);
    expect(fakeBarcode.productToReturn, isNull);
    expect(find.text('Nie znaleziono produktu w bazie.'), findsOneWidget);
    expect(fakeCalc.recalculateCalled, isFalse);
  });

  testWidgets('Kolor ikony zmienia się w zależności od stanu', (tester) async {
    await tester.pumpWidget(createTestWidget());

    Icon icon = tester.widget(find.byIcon(Icons.qr_code_scanner));
    expect(icon.color, Colors.limeAccent);

    fakeBarcode.scanBarcode('123');
    await tester.pumpAndSettle();
    
    icon = tester.widget(find.byIcon(Icons.qr_code_scanner));
    expect(icon.color, Colors.lightGreenAccent);
  });
}