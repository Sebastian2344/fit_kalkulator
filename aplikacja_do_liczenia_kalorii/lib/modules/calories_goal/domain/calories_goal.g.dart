// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calories_goal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalorieGoal)
final calorieGoalProvider = CalorieGoalProvider._();

final class CalorieGoalProvider extends $NotifierProvider<CalorieGoal, int> {
  CalorieGoalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calorieGoalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calorieGoalHash();

  @$internal
  @override
  CalorieGoal create() => CalorieGoal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$calorieGoalHash() => r'd199723faef46e47953d3a7f56ad88c846e95cbc';

abstract class _$CalorieGoal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
