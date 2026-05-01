import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/mass_textfield.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
  late FakeCalcNotifier fakeCalcNotifier;
  setUp(() {
    fakeCalcNotifier = FakeCalcNotifier();
  });

  testWidgets('textfield should call method', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calcInDialogProvider.overrideWith(() => fakeCalcNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MassTextfield(weightController: TextEditingController()),
          ),
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, '150');
      await tester.pump(Duration(seconds: 1)); // Wait for debouncer to trigger

    expect(fakeCalcNotifier.recalculateCalled, isTrue);
    expect(fakeCalcNotifier.capturedProduct, isNotNull);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('Waga (g)'), findsOneWidget);
    expect(find.byIcon(Icons.scale), findsOneWidget);
  });
  
}
