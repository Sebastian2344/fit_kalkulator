import 'package:hive_ce/hive_ce.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
class Meal {
  final String id;
  final String name;
  final int calories;
  final int weight;
  final DateTime date;
  // Nowe pola makro
  final double protein;
  final double fat;
  final double carbs;

  Meal({
    String? id,
    required this.name,
    required this.calories,
    required this.weight,
    required this.date,
    required this.protein,
    required this.fat,
    required this.carbs,
  }) : id = id ?? _uuid.v4();
}

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final typeId = 0;

  @override
  Meal read(BinaryReader reader) {
    return Meal(
      id: reader.read(),
      name: reader.read(),
      calories: reader.read(),
      weight: reader.read(),
      date: reader.read(),
      protein: reader.read(),
      fat: reader.read(),
      carbs: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.calories);
    writer.write(obj.weight);
    writer.write(obj.date);
    writer.write(obj.protein);
    writer.write(obj.fat);
    writer.write(obj.carbs);
  }
}