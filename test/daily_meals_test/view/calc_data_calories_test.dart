import 'package:aplikacja_do_liczenia_kalorii/core/entity/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/calc_data.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/view/calc_data_calories.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockCalcNotifier extends CalcInDialog {
  final CalcData state1;
  
  MockCalcNotifier(this.state1);
  
  @override
  CalcData build() => state1;
}
void main() {
  // Funkcja pomocnicza do budowania widgetu z nadpisanym providerem
  Widget createTestWidget(CalcData state) {
    return ProviderScope(
      overrides: [
        // Nadpisujemy provider konkretnym stanem
        calcInDialogProvider.overrideWith(() => MockCalcNotifier(state)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: CalcDataCalories(),
        ),
      ),
    );
  }

  testWidgets('Powinien zwrócić SizedBox (pusty), gdy nazwa produktu jest pusta', (tester) async {
    final emptyState = CalcData(product: const Product(name: "", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1), calories: 1, carbs: 1, protein: 1, fat: 1);

    await tester.pumpWidget(createTestWidget(emptyState));

    // Sprawdzamy czy Container (główny element widgetu) NIE istnieje
    expect(find.byType(Container), findsNothing);
    // Sprawdzamy czy tekst "kcal" NIE istnieje
    expect(find.textContaining('kcal'), findsNothing);
  });

  testWidgets('Powinien wyświetlić poprawne wartości makroskładników', (tester) async {
    final dataState = CalcData(
      product: const Product(name: "Kurczak", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1),
      calories: 250,
      protein: 30.5,
      fat: 10.25, // Zostanie zaokrąglone do 10.3 przez toStringAsFixed(1)
      carbs: 0.0,
    );

    await tester.pumpWidget(createTestWidget(dataState));

    // 1. Sprawdzamy kalorie
    expect(find.text('250 kcal'), findsOneWidget);

    // 2. Sprawdzamy etykiety (Labels)
    expect(find.text('Białko'), findsOneWidget);
    expect(find.text('Tłuszcze'), findsOneWidget);
    expect(find.text('Węgle'), findsOneWidget);

    // 3. Sprawdzamy sformatowane wartości (g)
    expect(find.text('30.5g'), findsOneWidget);
    expect(find.text('10.3g'), findsOneWidget); // Zaokrąglenie fat
    expect(find.text('0.0g'), findsOneWidget);
  });

  testWidgets('Tekst kalorii powinien mieć zielony kolor i pogrubienie', (tester) async {
    final dataState = CalcData(
      product: const Product(name: "Kurczak", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1),
      calories: 200, carbs: 1, protein: 1, fat: 1,
    );

    await tester.pumpWidget(createTestWidget(dataState));

    final Text kcalText = tester.widget(find.text('200 kcal'));
    
    expect(kcalText.style?.color, Colors.green);
    expect(kcalText.style?.fontWeight, FontWeight.bold);
    expect(kcalText.style?.fontSize, 20);
  });

  testWidgets('Etykieta Białko powinna mieć niebieski kolor', (tester) async {
    final dataState = CalcData(product: const Product(name: "A", kcalPer100g: 1, proteinPer100g: 1, fatPer100g: 1, carbsPer100g: 1), calories: 1, carbs: 1, protein: 1, fat: 1);
    await tester.pumpWidget(createTestWidget(dataState));

    // Szukamy tekstu "Białko"
    final Text proteinLabel = tester.widget(find.text('Białko'));
    
    expect(proteinLabel.style?.color, Colors.blue);
  });
}