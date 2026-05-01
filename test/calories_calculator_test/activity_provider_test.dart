import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/activity_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late ProviderContainer container;
  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('ActivityLevelProvider should return default activity level', () {
    expect(container.read(activityLevelProvider), ActivityLevel.sedentary);
  });

  test('ActivityLevelProvider should update activity level', () {
    container.read(activityLevelProvider.notifier).setActivityLevel(ActivityLevel.active);
    expect(container.read(activityLevelProvider), ActivityLevel.active);
  });
}