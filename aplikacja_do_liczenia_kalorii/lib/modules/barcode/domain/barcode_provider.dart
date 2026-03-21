import 'package:aplikacja_do_liczenia_kalorii/core/model/product.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/data/repo/repo_barcode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'barcode_provider.g.dart';

@riverpod
class BarcodeProvider extends _$BarcodeProvider {
  late final RepoBarcode repo;

  @override
  FutureOr<Product?> build() {
    repo = ref.read(repoBarcodeProvider);
    return null; // Początkowo brak produktu
  }


  Future<void> scanBarcode(String barcode) async {
    state = const AsyncValue<Product?>.loading();
    try {
      final product = await repo.fetchProductByBarcode(barcode);
      state = AsyncValue.data(product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);     
    }
  }
}