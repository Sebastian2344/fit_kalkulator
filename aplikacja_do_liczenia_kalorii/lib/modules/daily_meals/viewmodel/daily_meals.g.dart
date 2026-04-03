// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_meals.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DailyMeals)
final dailyMealsProvider = DailyMealsProvider._();

final class DailyMealsProvider
    extends $NotifierProvider<DailyMeals, List<Meal>> {
  DailyMealsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyMealsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyMealsHash();

  @$internal
  @override
  DailyMeals create() => DailyMeals();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Meal> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Meal>>(value),
    );
  }
}

String _$dailyMealsHash() => r'156afe687fff69c7468b33a1ec4dcb7b803a4e0b';

abstract class _$DailyMeals extends $Notifier<List<Meal>> {
  List<Meal> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Meal>, List<Meal>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Meal>, List<Meal>>,
              List<Meal>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
