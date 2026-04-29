import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/viewmodel/gender_provider.dart';
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
  
  test('GenderProvider should return default gender', () {
    expect(container.read(genderProvider), Gender.male);
  });

  test('GenderProvider should update gender', () {
    container.read(genderProvider.notifier).setGender(Gender.female);
    expect(container.read(genderProvider), Gender.female);
  });
}  