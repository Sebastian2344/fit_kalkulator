// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_meals.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealsBox)
final mealsBoxProvider = MealsBoxProvider._();

final class MealsBoxProvider
    extends $FunctionalProvider<Box<Meal>, Box<Meal>, Box<Meal>>
    with $Provider<Box<Meal>> {
  MealsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealsBoxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<Meal>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<Meal> create(Ref ref) {
    return mealsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<Meal> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<Meal>>(value),
    );
  }
}

String _$mealsBoxHash() => r'4376523ee2816d2d3f5e227efb2c1a4017be258b';

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

String _$dailyMealsHash() => r'd0e316cbd5d14aa2d5974ab9448e7dcc3f2e8d9b';

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
