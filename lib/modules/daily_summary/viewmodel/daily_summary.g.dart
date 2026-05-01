// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailySummary)
final dailySummaryProvider = DailySummaryProvider._();

final class DailySummaryProvider
    extends $FunctionalProvider<DailySummary, DailySummary, DailySummary>
    with $Provider<DailySummary> {
  DailySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailySummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailySummaryHash();

  @$internal
  @override
  $ProviderElement<DailySummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DailySummary create(Ref ref) {
    return dailySummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailySummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailySummary>(value),
    );
  }
}

String _$dailySummaryHash() => r'f4634e46341a4d49a8619f5659da467a600fa5c9';
