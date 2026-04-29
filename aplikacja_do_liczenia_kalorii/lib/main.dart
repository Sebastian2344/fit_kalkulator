import 'package:aplikacja_do_liczenia_kalorii/modules/home_screen/home_screen.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/model/meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

Future<void> main() async {
  // Inicjalizacja Hive
  await Hive.initFlutter();

  // Rejestracja adaptera (wygenerowanego przez build_runner)
  Hive.registerAdapter(MealAdapter());

  // Otwarcie pudełek (Box)
  await Hive.openBox<Meal>('meals');
  await Hive.openBox('settings');

  runApp(const ProviderScope(child: CalorieApp()));
}

class CalorieApp extends StatelessWidget {
  const CalorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green, // Zmieniamy motyw na zielony (fit)
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}