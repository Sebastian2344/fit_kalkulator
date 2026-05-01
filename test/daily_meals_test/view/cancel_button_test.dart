import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/cancel_button.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// --- KLASY POMOCNICZE ---

// 1. FAKE dla Providera (Bezpieczne dla Riverpoda)
class FakeCalcInDialog extends CalcInDialog {
  final CalcData _initialState;
  bool wasResetCalled = false; // Zmienna do weryfikacji, czy wywołano metodę

  FakeCalcInDialog(this._initialState);

  @override
  CalcData build() => _initialState;

  @override
  void reset() {
    wasResetCalled = true; // Zamiast mocktailowego verify(), po prostu zmieniamy flagę
  }
}

// 2. MOCK dla Nawigacji (Idealne użycie mocktaila)
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeRoute extends Fake implements Route<dynamic> {}

// --- TESTY ---

void main() {
  late FakeCalcInDialog fakeCalcInDialog;
  late MockNavigatorObserver mockObserver;

  setUpAll(() {
    // Super! Zarejestrowanie FakeRoute dla any() w mocktailu
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    fakeCalcInDialog = FakeCalcInDialog(const CalcData(
      product: Product(name: "", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1),
      calories: 0,
      carbs: 0,
      protein: 0,
      fat: 0,
    ));
    mockObserver = MockNavigatorObserver();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides:[
        // Podpinamy naszego Fake'a
        calcInDialogProvider.overrideWith(() => fakeCalcInDialog),
      ],
      child: MaterialApp(
        navigatorObservers: [mockObserver],
        home: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Scaffold(body: CancelButton())),
            ),
            child: const Text("Open"),
          );
        }),
      ),
    );
  }

  testWidgets('CancelButton powinien zresetować stan i zamknąć ekran', (tester) async {
    await tester.pumpWidget(createTestWidget());

    // 1. Otwieramy ekran z przyciskiem "Anuluj"
    await tester.tap(find.text("Open"));
    await tester.pumpAndSettle();

    // 2. Klikamy "Anuluj"
    await tester.tap(find.text("Anuluj"));
    await tester.pumpAndSettle();

    // 3. Weryfikacja metody reset z użyciem flagi z Fake'a
    expect(fakeCalcInDialog.wasResetCalled, isTrue);

    // 4. Weryfikacja nawigacji z użyciem potęgi mocktaila
    verify(() => mockObserver.didPop(any(), any())).called(1);
    expect(find.text("Anuluj"), findsNothing);
    expect(find.text("Open"), findsOneWidget);
  });
}