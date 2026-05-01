// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BarcodeProvider)
final barcodeProviderProvider = BarcodeProviderProvider._();

final class BarcodeProviderProvider
    extends $AsyncNotifierProvider<BarcodeProvider, Product?> {
  BarcodeProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeProviderHash();

  @$internal
  @override
  BarcodeProvider create() => BarcodeProvider();
}

String _$barcodeProviderHash() => r'8082f768c53ca3d9b81eb6654f8a09c7df3bd66e';

abstract class _$BarcodeProvider extends $AsyncNotifier<Product?> {
  FutureOr<Product?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Product?>, Product?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Product?>, Product?>,
              AsyncValue<Product?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
