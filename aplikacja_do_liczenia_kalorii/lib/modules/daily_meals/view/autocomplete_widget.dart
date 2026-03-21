import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/domain/barcode_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/domain/calc_in_dialog.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/food_db/product_db.dart';
import 'package:aplikacja_do_liczenia_kalorii/core/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutocompleteWidget extends ConsumerWidget {
  const AutocompleteWidget({super.key, required this.weightController});
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.read(productsDatabaseProvider);
    return Autocomplete<Product>(
      displayStringForOption: (option) => option.name,
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) return const Iterable<Product>.empty();
        return products.values.where((Product option) {
          return option.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (selection) {
        ref
            .read(calcInDialogProvider.notifier)
            .recalculate(selection, weightController);
      },
      fieldViewBuilder: (context, controller, focus, _) {
        final scannedProductNameToFill = ref.watch(
          barcodeProviderProvider.select((state) => state.value?.name),
        );
        if (scannedProductNameToFill != null) {
          controller.text = scannedProductNameToFill;
        }

        return TextField(
          controller: controller,
          focusNode: focus,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: "Produkt",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            if (scannedProductNameToFill != null) {
              return;
            }
            if (value.isEmpty) {
              ref.read(calcInDialogProvider.notifier).reset();
            }
            String s = value.toLowerCase();
            s = s[0].toUpperCase() + s.substring(1);
            final selectedProduct = products[s];
            if (selectedProduct != null && selectedProduct.name.isNotEmpty) {
              ref.read(calcInDialogProvider.notifier).recalculate(
                selectedProduct,
                weightController,
              );
            }
          },
        );
      },
    );
  }
}
