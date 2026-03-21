import 'package:equatable/equatable.dart';

enum Gender { male, female }

enum ActivityLevel {
  sedentary(1.2, 'Brak aktywności'),
  light(1.375, 'Lekka aktywność'),
  moderate(1.55, 'Średnia aktywność'),
  active(1.725, 'Wysoka aktywność'),
  veryActive(1.9, 'Bardzo wysoka aktywność');

  final double multiplier;
  final String description;
  const ActivityLevel(this.multiplier, this.description);
}

class UserStats {
  final Gender gender;
  final int age;
  final double weight;
  final double height;
  final ActivityLevel activityLevel;

  UserStats({
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
  });
}

class CalorieResult extends Equatable {
  final double bmr;
  final double tdee;

  const CalorieResult({required this.bmr, required this.tdee});

  @override
  List<Object?> get props => [bmr, tdee];
}