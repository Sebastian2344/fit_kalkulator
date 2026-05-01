import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'calories_goal.g.dart';

@riverpod
Box settingsBox(Ref ref) => Hive.box('settings');

@riverpod
class CalorieGoal extends _$CalorieGoal {
  @override
  int build() {
    // 2. Watchujemy box zamiast otwierać go bezpośrednio
    final box = ref.watch(settingsBoxProvider);
    return box.get('daily_goal', defaultValue: 2500);
  }

  void setGoal(int newGoal) {
    state = newGoal;
    // 3. Używamy boxa przez ref
    ref.read(settingsBoxProvider).put('daily_goal', newGoal);
  }
}