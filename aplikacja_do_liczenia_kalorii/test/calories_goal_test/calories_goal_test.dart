import 'package:aplikacja_do_liczenia_kalorii/modules/calories_goal/viewmodel/calories_goal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';

class FakeHiveBox extends Mock implements Box {}

void main(){
  late ProviderContainer container;
  late FakeHiveBox fakeHiveBox;
  setUp(() {
    fakeHiveBox = FakeHiveBox();
    container = ProviderContainer(
      overrides: [
        settingsBoxProvider.overrideWithValue(fakeHiveBox),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('CaloriesGoalController should return initial value', () {
  // Musisz powiedzieć Mockowi, co ma zwrócić:
  when(()=>fakeHiveBox.get('daily_goal', defaultValue: 2500)).thenReturn(2500);

  expect(container.read(calorieGoalProvider), 2500);
});

test('CaloriesGoalController should update the goal', () {
  // Programujemy początek
  when(()=>fakeHiveBox.get('daily_goal', defaultValue: 2500)).thenReturn(2500);
  // Programujemy put, żeby nie rzucał błędem (put zwraca Future<void>)
  when(()=>fakeHiveBox.put(any(), any())).thenAnswer((_) async => Future.value());

  final controller = container.read(calorieGoalProvider.notifier);
  controller.setGoal(3000);

  expect(container.read(calorieGoalProvider), 3000);
  // Weryfikujemy czy put został wywołany
  verify(()=>fakeHiveBox.put('daily_goal', 3000)).called(1);
});
}
