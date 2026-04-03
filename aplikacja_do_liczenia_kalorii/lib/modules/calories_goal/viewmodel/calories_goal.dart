import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'calories_goal.g.dart';

@riverpod
class CalorieGoal extends _$CalorieGoal {
  late Box _settingsBox;

  @override
  int build() {
    _settingsBox = Hive.box('settings');
    // Pobierz zapisany cel lub domyślnie 2500
    return _settingsBox.get('daily_goal', defaultValue: 2500);
  }

  void setGoal(int newGoal) {
    state = newGoal;
    _settingsBox.put('daily_goal', newGoal);
  }
}