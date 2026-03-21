import 'package:aplikacja_do_liczenia_kalorii/modules/calories_calculator/data/model/calories_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class GenderState extends Equatable {
  final Gender result;
  const GenderState({required this.result});

  GenderState copyWith({Gender? result}) {
    return GenderState(result: result ?? this.result);
  }

  @override
  List<Object?> get props => [result];
}

class GenderProvider extends Notifier<GenderState> {
  @override 
  GenderState build() {
    return GenderState(result: Gender.male);
  }

  void setGender(Gender gender) {
    state = state.copyWith(result: gender);   
  }
}

final genderProvider = NotifierProvider<GenderProvider, GenderState>(() {
  return GenderProvider();
});