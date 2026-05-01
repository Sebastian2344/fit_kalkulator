import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenderProvider extends Notifier<Gender> {
  @override 
  Gender build() {
    return Gender.male;
  }

  void setGender(Gender gender) {
    state = gender;   
  }
}

final genderProvider = NotifierProvider<GenderProvider, Gender>(() {
  return GenderProvider();
});