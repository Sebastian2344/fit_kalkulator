// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_db.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productsDatabase)
final productsDatabaseProvider = ProductsDatabaseProvider._();

final class ProductsDatabaseProvider
    extends
        $FunctionalProvider<
          Map<String, Product>,
          Map<String, Product>,
          Map<String, Product>
        >
    with $Provider<Map<String, Product>> {
  ProductsDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsDatabaseHash();

  @$internal
  @override
  $ProviderElement<Map<String, Product>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, Product> create(Ref ref) {
    return productsDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Product>>(value),
    );
  }
}

String _$productsDatabaseHash() => r'8f725908ed93774914a5e9b6205caa7c4e29a2d6';
