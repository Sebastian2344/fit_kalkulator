import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/model/calories_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityLevelProvider extends Notifier<ActivityLevel> {
  @override 
  ActivityLevel build() {
    return ActivityLevel.sedentary;
  }

  void setActivityLevel(ActivityLevel level) {
    state = level;   
  }
}

final activityLevelProvider = NotifierProvider<ActivityLevelProvider, ActivityLevel>(() {
  return ActivityLevelProvider();
});
