import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/view/sex_choice_widget.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/gender_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeGenderNotifier extends GenderProvider {
  final Gender _initialGender;

  FakeGenderNotifier(this._initialGender);

  @override
  Gender build() => _initialGender;

  @override
  void setGender(Gender gender) {
    state = gender;
  }
}

void main() {
  // Funkcja pomocnicza do renderowania widżetu
  Future<ProviderContainer> pumpWidgetWithState(
    WidgetTester tester,
    Gender initialGender,
  ) async {
    final container = ProviderContainer(
      overrides: [
        genderProvider.overrideWith(() => FakeGenderNotifier(initialGender)),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SexChoiceWidget(),
          ),
        ),
      ),
    );

    return container;
  }

  // Funkcja pomocnicza ułatwiająca wyciąganie statusu 'selected' z ChoiceChip
  bool isChipSelected(WidgetTester tester, String labelText) {
    // Szukamy widżetu ChoiceChip, który wewnątrz ma tekst labelText
    final finder = find.widgetWithText(ChoiceChip, labelText);
    // Wyciągamy fizyczny widżet z drzewa
    final chipWidget = tester.widget<ChoiceChip>(finder);
    // Zwracamy jego właściwość 'selected'
    return chipWidget.selected;
  }
  group('tests', () {
    testWidgets('Should render both gender choice chips', (tester) async {
      await pumpWidgetWithState(tester, Gender.male);

    expect(find.text('Mężczyzna'), findsOneWidget);
    expect(find.text('Kobieta'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(2));
  });

  testWidgets('Men should be selected by default if the initial state is male', (tester) async {
    await pumpWidgetWithState(tester, Gender.male);

    // Sprawdzamy wizualny stan przycisków
    expect(isChipSelected(tester, 'Mężczyzna'), isTrue);
    expect(isChipSelected(tester, 'Kobieta'), isFalse);
  });

  testWidgets('Women should be selected by default if the initial state is female', (tester) async {
    await pumpWidgetWithState(tester, Gender.female);

    expect(isChipSelected(tester, 'Mężczyzna'), isFalse);
    expect(isChipSelected(tester, 'Kobieta'), isTrue);
  });

  testWidgets('Clicking on Female should change the provider state and UI selection', (tester) async {
    // Odpalamy z domyślnym stanem: Mężczyzna
    final container = await pumpWidgetWithState(tester, Gender.male);
    addTearDown(container.dispose);

    // Klikamy w chip z napisem Kobieta
    await tester.tap(find.text('Kobieta'));
    await tester.pump(); // Czekamy na przebudowanie UI

    // Weryfikacja 1: Stan widżetów się zaktualizował
    expect(isChipSelected(tester, 'Mężczyzna'), isFalse);
    expect(isChipSelected(tester, 'Kobieta'), isTrue);

    // Weryfikacja 2: Provider zmienił swój stan w tle na female
    expect(container.read(genderProvider), Gender.female);
  });

  testWidgets('Clicking on Male should change the provider state and UI selection', (tester) async {
    // Odpalamy z domyślnym stanem: Kobieta
    final container = await pumpWidgetWithState(tester, Gender.female);
    addTearDown(container.dispose);

    // Klikamy w chip z napisem Mężczyzna
    await tester.tap(find.text('Mężczyzna'));
    await tester.pump();

    // Weryfikacja
    expect(isChipSelected(tester, 'Mężczyzna'), isTrue);
    expect(isChipSelected(tester, 'Kobieta'), isFalse);
    expect(container.read(genderProvider), Gender.male);
  });
  });
} 