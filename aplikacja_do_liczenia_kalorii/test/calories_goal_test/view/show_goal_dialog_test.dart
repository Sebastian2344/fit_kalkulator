import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/view/show_goal_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Zaimportuj swój plik z widżetem i providerem
// import 'package:twoja_aplikacja/sciezka/do/calorie_goal.dart'; 

// 1. Tworzymy klasę Fake, aby kontrolować logikę i pozbyć się zależności od Hive
class FakeCalorieGoal extends CalorieGoal {
  final int _initialGoal;
  
  FakeCalorieGoal(this._initialGoal);

  @override
  int build() => _initialGoal;

  @override
  void setGoal(int newGoal) {
    // Nadpisujemy metodę setGoal, aby tylko zmieniała stan.
    // Pomijamy odwołanie do Hive (ref.read(settingsBoxProvider).put),
    // dzięki czemu testy uruchamiają się błyskawicznie i nie rzucają błędów bazy.
    state = newGoal;
  }
}

void main() {
  // Funkcja pomocnicza budująca środowisko testowe
  Future<ProviderContainer> pumpTestDialog(WidgetTester tester, int initialGoal) async {
    // Używamy ProviderContainer, aby mieć łatwy dostęp do odczytywania 
    // stanu providera po wykonaniu akcji (np. po kliknięciu "Zapisz")
    final container = ProviderContainer(
      overrides:[
        calorieGoalProvider.overrideWith(() => FakeCalorieGoal(initialGoal)),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            // Tworzymy prosty guzik, który otworzy nasz dialog. 
            // Dzięki temu `Navigator.pop` będzie miał co zamknąć.
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const ShowGoalDialog(),
                ),
                child: const Text('Otwórz dialog'),
              ),
            ),
          ),
        ),
      ),
    );

    // Otwieramy dialog przed rozpoczęciem każdego z testów
    await tester.tap(find.text('Otwórz dialog'));
    await tester.pumpAndSettle(); // Czekamy na zakończenie animacji otwierania

    return container;
  }

  testWidgets('Powinien zainicjować TextField z początkową wartością', (tester) async {
    final container = await pumpTestDialog(tester, 2500);
    addTearDown(container.dispose);

    // Sprawdzamy czy dialog się wyrenderował i ma odpowiedni tekst
    expect(find.text('Zmień cel kalorii'), findsOneWidget);
    
    // Upewniamy się, że kontroler pobrał wartość 2500
    expect(find.text('2500'), findsOneWidget);
  });

  testWidgets('Kliknięcie Anuluj zamyka dialog bez zmiany stanu', (tester) async {
    final container = await pumpTestDialog(tester, 2000);
    addTearDown(container.dispose);

    // Wpisujemy nową wartość, ale anulujemy
    await tester.enterText(find.byType(TextField), '3000');
    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle(); // Czekamy na zamknięcie dialogu

    // Dialog powinien zniknąć z drzewa widżetów
    expect(find.byType(AlertDialog), findsNothing);

    // Stan providera NIE powinien się zmienić
    expect(container.read(calorieGoalProvider), 2000);
  });

  testWidgets('Kliknięcie Zapisz z poprawną wartością zmienia cel i zamyka dialog', (tester) async {
    final container = await pumpTestDialog(tester, 2200);
    addTearDown(container.dispose);

    // Wpisujemy poprawną, nową wartość
    await tester.enterText(find.byType(TextField), '3500');
    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    // Dialog zniknął
    expect(find.byType(AlertDialog), findsNothing);

    // Wartość providera została pomyślnie zaktualizowana
    expect(container.read(calorieGoalProvider), 3500);
  });

  testWidgets('Wpisanie wartości 0 nic nie robi (nie zamyka dialogu ani nie zmienia celu)', (tester) async {
    final container = await pumpTestDialog(tester, 2500);
    addTearDown(container.dispose);

    await tester.enterText(find.byType(TextField), '0');
    await tester.tap(find.text('Zapisz'));
    await tester.pump(); // Nie używamy pumpAndSettle, bo nie ma żadnej animacji do zakończenia

    // Dialog wciąż powinien być widoczny
    expect(find.byType(AlertDialog), findsOneWidget);

    // Wartość pozostaje bez zmian
    expect(container.read(calorieGoalProvider), 2500);
  });

  testWidgets('Puste pole nie zamyka dialogu (wartość null po parsowaniu)', (tester) async {
    final container = await pumpTestDialog(tester, 2500);
    addTearDown(container.dispose);

    // Kasujemy cały tekst z pola
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Zapisz'));
    await tester.pump();

    // Dialog wciąż jest otwarty
    expect(find.byType(AlertDialog), findsOneWidget);
    
    // Wartość pozostaje bez zmian
    expect(container.read(calorieGoalProvider), 2500);
  });

  testWidgets('Wprowadzenie liter jest ignorowane dzięki formatterom', (tester) async {
    final container = await pumpTestDialog(tester, 2500);
    addTearDown(container.dispose);

    // Próbujemy wpisać litery i cyfry
    await tester.enterText(find.byType(TextField), 'abc300');
    await tester.pump();

    // Wyciągamy kontroler TextField, by sprawdzić jego wartość
    final textField = tester.widget<TextField>(find.byType(TextField));
    
    // Formatter (FilteringTextInputFormatter.digitsOnly) powinien wyłuskać tylko "300"
    expect(textField.controller?.text, '300');
  });
}