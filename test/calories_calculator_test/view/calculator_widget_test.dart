import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/view/calculator.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/activity_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/calculator_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/gender_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCalculatorController extends CalculatorController {
  bool wasCalculateCalled = false;
  bool wasResetCalled = false;
  UserStats? receivedStats;

  @override
  CalorieResult? build() => null;

  // Symulujemy metodę z Twojego Notifiera
  @override
  void calculate(UserStats stats) {
    wasCalculateCalled = true;
    receivedStats = stats;
  }

  // Symulujemy metodę reset
  @override
  void reset() {
    wasResetCalled = true;
  }
}

// 2. Fake dla Płci
class FakeGenderNotifier extends GenderProvider {
  @override
  Gender build() => Gender.female; // Ustawiamy domyślnie na kobietę, by test resetu (na mężczyznę) miał sens

  @override
  void setGender(Gender gender) => state = gender;
}

// 3. Fake dla Aktywności
class FakeActivityLevelNotifier extends ActivityLevelProvider {
  @override
  ActivityLevel build() => ActivityLevel.veryActive; // Ustawiamy na wysoką, by przetestować reset do sedentary

  @override
  void setActivityLevel(ActivityLevel level) => state = level;
}

// --- TESTY ---

void main() {
  late FakeCalculatorController fakeCalculator;
  late FakeGenderNotifier fakeGender;
  late FakeActivityLevelNotifier fakeActivity;

  // Ta funkcja będzie odpalana przed KAZDYM testem (czyści stan)
  setUp(() {
    fakeCalculator = FakeCalculatorController();
    fakeGender = FakeGenderNotifier();
    fakeActivity = FakeActivityLevelNotifier();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        // Podmieniamy prawdziwe providery naszymi Fake'ami
        calculatorControllerProvider.overrideWith(() => fakeCalculator),
        genderProvider.overrideWith(() => fakeGender),
        activityLevelProvider.overrideWith(() => fakeActivity),
      ],
      child: const MaterialApp(home: CalculatorScreen()),
    );
  }

  group('tests', () {
    testWidgets('Should render all text fields and button', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Kalkulator Kalorii'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // Wiek, Waga, Wzrost
      expect(
        find.byType(DropdownButtonFormField<ActivityLevel>),
        findsOneWidget,
      );
      expect(find.text('OBLICZ'), findsOneWidget);
    });

    testWidgets('Should show validation errors when the form is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Klikamy Oblicz bez wpisywania danych
      await tester.tap(find.text('OBLICZ'));
      await tester
          .pump(); // Czekamy na przerysowanie klatek (pojawienie się czerwonych tekstów)

      // Sprawdzamy, czy walidatory zwróciły błędy
      expect(find.text('Podaj wiek'), findsOneWidget);
      expect(find.text('Podaj wagę'), findsOneWidget);
      expect(find.text('Podaj wzrost'), findsOneWidget);

      // Kontroler nie powinien zostać wywołany (bo walidacja nie przeszła)
      expect(fakeCalculator.wasCalculateCalled, isFalse);
    });

    testWidgets(
      'Should correctly gather data and call calculate() when data is valid',
      (tester) async {
        await tester.pumpWidget(createTestWidget());

        // 1. Wpisujemy poprawne dane w pola
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Wiek'),
          '28',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Waga (kg)'),
          '75.5',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Wzrost (cm)'),
          '182',
        );

        // Czekamy na "wpisanie" tekstu
        await tester.pump();

        // 2. Klikamy przycisk
        await tester.tap(find.text('OBLICZ'));
        await tester.pump();

        // 3. Weryfikacja:
        // Czy metoda calculate() została wywołana?
        expect(fakeCalculator.wasCalculateCalled, isTrue);

        // Czy model UserStats został utworzony z poprawnymi danymi z TextFieldów?
        final stats = fakeCalculator.receivedStats;
        expect(stats, isNotNull);
        expect(stats!.age, 28);
        expect(stats.weight, 75.5);
        expect(stats.height, 182.0);
        // Sprawdzamy czy pobrało aktualny stan z Fake'ów (domyślnie ustawiliśmy female i veryActive w setupie)
        expect(stats.gender, Gender.female);
        expect(stats.activityLevel, ActivityLevel.veryActive);
      },
    );

    testWidgets(
      'Reset button on AppBar should clear the form and reset the state',
      (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Wpisujemy cokolwiek, żeby sprawdzić czy zniknie
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Wiek'),
          '40',
        );
        await tester.pump();

        // Sprawdzamy czy wpisany tekst na pewno tam jest
        expect(find.text('40'), findsOneWidget);

        // Klikamy ikonę odświeżania (Reset) na AppBarze
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();

        // Weryfikacja 1: Pola tekstowe są puste (nie ma już tekstu '40')
        expect(find.text('40'), findsNothing);

        // Weryfikacja 2: Provider płci zresetowany do 'male'
        expect(fakeGender.state, Gender.male);

        // Weryfikacja 3: Provider aktywności zresetowany do 'sedentary'
        expect(fakeActivity.state, ActivityLevel.sedentary);

        // Weryfikacja 4: Provider kalkulatora wywołał reset()
        expect(fakeCalculator.wasResetCalled, isTrue);
      },
    );
  });
}
