import 'dart:async';

import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/viewmodel/barcode_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/autocomplete_widget.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/food_db/product_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// --- KLASY FAKE (Stabilniejsze dla Riverpoda) ---

class FakeCalcNotifier extends CalcInDialog {
  bool recalculateCalled = false;
  Product? lastProduct;

  @override
  CalcData build() => CalcData(product: Product(name: '', kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1), calories: 1, carbs: 1, protein: 1, fat: 1); // Zwróć swój początkowy stan

  @override
  void recalculate(Product product, TextEditingController controller) {
    recalculateCalled = true;
    lastProduct = product;
  }
}
class FakeBarcodeNotifier extends BarcodeProvider {
  final AsyncValue<Product?> mockValue;
  FakeBarcodeNotifier(this.mockValue);

  @override
  FutureOr<Product?> build() {
    // Zwracamy wartość z mockValue (obsługując stany data/error/loading)
    return mockValue.when(
      data: (data) => data,
      error: (e, s) => throw e,
      loading: () => Completer<Product?>().future, // Symulacja ładowania
    );
  }
}

void main() {
  late TextEditingController weightController;
  late FakeCalcNotifier fakeCalc;

  final productsMap = {
    'Apple': Product(name: 'Apple', kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1),
    'Banana': Product(name: 'Banana', kcalPer100g: 2, proteinPer100g: 2, fatPer100g: 2, carbsPer100g: 2),
  };

  setUp(() {
    weightController = TextEditingController();
    fakeCalc = FakeCalcNotifier();
  });

  // Pomocnicza funkcja do budowania widgetu
  Widget createTestWidget({
    AsyncValue<Product?> barcodeValue = const AsyncValue.data(null),
  }) {
    return ProviderScope(
      overrides: [
        // 1. Nadpisujemy bazę produktów
        productsDatabaseProvider.overrideWithValue(productsMap),
        
        // 2. Podpinamy naszą instancję Fake'a
        calcInDialogProvider.overrideWith(() => fakeCalc),
        
        // 3. Nadpisujemy barcodeProvider konkretną wartością przekazaną w parametrze
        barcodeProviderProvider.overrideWith(() => FakeBarcodeNotifier(barcodeValue)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: AutocompleteWidget(weightController: weightController),
        ),
      ),
    );
  }

  group('AutocompleteWidget Tests', () {
    testWidgets('Autocomplete powinien pokazać sugestie po wpisaniu tekstu', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Wpisz "Ap"
      await tester.enterText(find.byType(TextField), 'Ap');
      
      // Bardzo ważne przy Autocomplete: pump() z czasem, bo Autocomplete ma debounce
      await tester.pump(const Duration(milliseconds: 300)); 
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsWidgets);
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('Wybranie opcji powinno wywołać recalculate', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Ap');
      await tester.pumpAndSettle();

      // Klikamy w opcję (często są wewnątrz widżetu typu TapRegion lub InkWell)
      await tester.tap(find.text('Apple').last); 
      await tester.pumpAndSettle();

      // Sprawdzamy stan naszego Fake'a
      expect(fakeCalc.recalculateCalled, isTrue);
      expect(fakeCalc.lastProduct?.name, 'Apple');
    });

    testWidgets('Powinien automatycznie uzupełnić pole, gdy barcodeProvider ma wartość', (tester) async {
      final scannedProduct = productsMap['Banana'];
      
      await tester.pumpWidget(createTestWidget(
        barcodeValue: AsyncValue.data(scannedProduct),
      ));

      // Czekamy na ewentualne Listenery
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Banana');
    });

    testWidgets('Wpisanie pełnej nazwy z małej litery powinno wywołać recalculate', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'apple');
      await tester.pumpAndSettle();

      expect(fakeCalc.recalculateCalled, isTrue);
      expect(fakeCalc.lastProduct?.name, 'Apple');
    });
  });
}