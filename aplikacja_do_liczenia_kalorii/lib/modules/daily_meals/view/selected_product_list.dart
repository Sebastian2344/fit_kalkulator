import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/viewmodel/daily_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedProductList extends ConsumerWidget {
  const SelectedProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(dailyMealsProvider);
    return Expanded(
      child: meals.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Brak posiłków. Dodaj coś!",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];

                // 1. Owijamy Card w Dismissible
                return Dismissible(
                  // Klucz musi być unikalny dla każdego elementu!
                  key: Key(meal.id),

                  // Kierunek przesuwania (od prawej do lewej)
                  direction: DismissDirection.endToStart,

                  // Co się dzieje po przesunięciu
                  onDismissed: (direction) {
                    // Usuwamy z bazy
                    ref.read(dailyMealsProvider.notifier).removeMeal(meal.id);

                    // Opcjonalnie: Pokazujemy pasek "Cofnij"
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Usunięto: ${meal.name}'),
                        action: SnackBarAction(
                          label: 'Cofnij',
                          onPressed: () {
                            ref.read(dailyMealsProvider.notifier).addMeal(meal);
                          },
                        ),
                      ),
                    );
                  },

                  // Tło widoczne podczas przesuwania (Czerwone z koszem)
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Zaokrąglenie takie jak w Card
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Usuń",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),

                  // Właściwy element listy
                  child: Card(
                    margin: EdgeInsets.zero, // Margines obsługuje ListView
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        meal.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${meal.weight}g'),
                          const SizedBox(height: 2),
                          // Małe kropki makroskładników
                          Row(
                            children: [
                              MicroTag(
                                label: "B",
                                val: meal.protein,
                                color: Colors.blue,
                              ),
                              MicroTag(
                                label: "T",
                                val: meal.fat,
                                color: Colors.orange,
                              ),
                              MicroTag(
                                label: "W",
                                val: meal.carbs,
                                color: Colors.brown,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${meal.calories} kcal',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Dodatkowy przycisk kosza, jeśli ktoś nie lubi przesuwać
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Usunąć posiłek?"),
                                  content: Text(
                                    "Czy na pewno chcesz usunąć ${meal.name}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Anuluj"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(dailyMealsProvider.notifier)
                                            .removeMeal(meal.id);
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text(
                                        "Usuń",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class MicroTag extends StatelessWidget {
  const MicroTag({
    super.key,
    required this.label,
    required this.val,
    required this.color,
  });
  final String label;
  final double val;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Text(
        "$label: ${val.toInt()}",
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}