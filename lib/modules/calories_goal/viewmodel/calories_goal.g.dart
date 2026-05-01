// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calories_goal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsBox)
final settingsBoxProvider = SettingsBoxProvider._();

final class SettingsBoxProvider
    extends $FunctionalProvider<Box<dynamic>, Box<dynamic>, Box<dynamic>>
    with $Provider<Box<dynamic>> {
  SettingsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsBoxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<dynamic>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<dynamic> create(Ref ref) {
    return settingsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<dynamic>>(value),
    );
  }
}

String _$settingsBoxHash() => r'a55a5a4854f303034f55ea860d69785c61a6a9f7';

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

String _$calorieGoalHash() => r'65658cd0c35f6c798a4d3b5e7f1408ad7698b468';

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
