import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/model/calories_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ActivityState extends Equatable {
  final ActivityLevel result;
  const ActivityState({required this.result});

  ActivityState copyWith({ActivityLevel? result}) {
    return ActivityState(result: result ?? this.result);
  }

  @override
  List<Object?> get props => [result];
}

class ActivityLevelProvider extends Notifier<ActivityState> {
  @override 
  ActivityState build() {
    return ActivityState(result: ActivityLevel.sedentary);
  }

  void setActivityLevel(ActivityLevel level) {
    state = state.copyWith(result: level);   
  }
}

final activityLevelProvider = NotifierProvider<ActivityLevelProvider, ActivityState>(() {
  return ActivityLevelProvider();
});