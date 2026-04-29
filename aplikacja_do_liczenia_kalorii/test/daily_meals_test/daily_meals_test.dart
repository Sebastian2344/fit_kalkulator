import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';

class FakeHiveBox extends Mock implements Box<Meal>{}
void main() {
  late ProviderContainer container;
  late FakeHiveBox fakeHiveBox;
  setUp(() {
    fakeHiveBox = FakeHiveBox();
    container = ProviderContainer(
      overrides: [
        mealsBoxProvider.overrideWithValue(fakeHiveBox),
      ]
    );
  });

  tearDown(() {
    container.dispose();
  });

  // Dodaj testy dla DailyMeals tutaj
  test('DailyMeals should return empty list initially', () {
    // Sprawdź, czy DailyMeals zwraca pustą listę na początku
      when(()=>fakeHiveBox.values).thenReturn([]);
      when(()=>fakeHiveBox.length).thenReturn(0);
     expect(container.read(dailyMealsProvider), []);
  });

  test('DailyMeals should add a meal correctly', () {
    // Przygotuj przykładowy posiłek
    final meal = Meal(
      name: 'Test Meal',
      calories: 500,
      carbs: 50,
      protein: 30,
      fat: 20,
      weight: 200,
      date: DateTime.now(),
    );

      when(()=>fakeHiveBox.put(meal.id, meal)).thenAnswer((_)=> Future.value());
      when(()=>fakeHiveBox.values).thenReturn([]);
      when(()=>fakeHiveBox.length).thenReturn(0);

    // Dodaj posiłek do DailyMeals
    container.read(dailyMealsProvider.notifier).addMeal(meal);

    // Sprawdź, czy posiłek został dodany do listy
    final meals = container.read(dailyMealsProvider);
    expect(meals.length, 1);
    expect(meals[0].name, 'Test Meal');
    expect(meals[0].calories, 500);
    expect(meals[0].carbs, 50);
    expect(meals[0].protein, 30);
    expect(meals[0].fat, 20);
  });

  test('DailyMeals should remove a meal correctly', () {
    // Przygotuj przykładowy posiłek
     final meal = Meal(
      name: 'Test Meal',
      calories: 500,
      carbs: 50,
      protein: 30,
      fat: 20,
      weight: 200,
      date: DateTime.now(),
    );
      when(()=>fakeHiveBox.put(meal.id, meal)).thenAnswer((_)=> Future.value());
      when(()=>fakeHiveBox.delete(meal.id)).thenAnswer((_)=> Future.value());
      when(()=>fakeHiveBox.values).thenReturn([]);
      when(()=>fakeHiveBox.length).thenReturn(0);
    // Dodaj posiłek do DailyMeals
    container.read(dailyMealsProvider.notifier).addMeal(meal);

    // Usuń posiłek z DailyMeals
    container.read(dailyMealsProvider.notifier).removeMeal(meal.id);

    // Sprawdź, czy posiłek został usunięty z listy
    final meals = container.read(dailyMealsProvider);
    expect(meals.length, 0);
  });

  test('DailyMeals should be remove all', (){
    final meal1 = Meal(
      name: 'Test Meal 1',
      calories: 500,
      carbs: 50,
      protein: 30,
      fat: 20,
      weight: 200,
      date: DateTime.now(),
    );
    final meal2 = Meal(
      name: 'Test Meal 2',
      calories: 300,
      carbs: 30,
      protein: 20,
      fat: 10,
      weight: 150,
      date: DateTime.now(),
    );
    when(()=>fakeHiveBox.put(meal1.id, meal1)).thenAnswer((_)=> Future.value());
    when(()=>fakeHiveBox.put(meal2.id, meal2)).thenAnswer((_)=> Future.value());
    when(()=>fakeHiveBox.clear()).thenAnswer((_)=> Future.value(1));
    when(()=>fakeHiveBox.values).thenReturn([]);
    when(()=>fakeHiveBox.length).thenReturn(0);
    container.read(dailyMealsProvider.notifier).addMeal(meal1);
    container.read(dailyMealsProvider.notifier).addMeal(meal2);

    container.read(dailyMealsProvider.notifier).clearMeals();

    final meals = container.read(dailyMealsProvider);
    expect(meals.length, 0);
  });
}