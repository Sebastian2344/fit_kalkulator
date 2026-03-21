import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/domain/barcode_provider.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/view/barcode_screen.dart';
import 'package:aplikacja_do_liczenia_kalorii/modules/daily_meals/domain/calc_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodeButton extends ConsumerWidget {
  const BarcodeButton({super.key, required this.weightController});
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeState = ref
        .watch(barcodeProviderProvider)
        .value; // Odświeżamy ikonę po zmianie stanu skanowania
    return IconButton.filled(
      onPressed: () async {
        final barcode = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
        );

        if (barcode != null) {
          if (!context.mounted) return;

          final scaffoldMessenger = ScaffoldMessenger.of(context);

          // Czyścimy poprzednie snackbary (żeby nie było kolejkowania)
          scaffoldMessenger.clearSnackBars();
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Szukam produktu...')),
          );

          // Pobieramy dane
          await ref.read(barcodeProviderProvider.notifier).scanBarcode(barcode);

          if (!context.mounted) return;

          final scannedProduct = ref.read(barcodeProviderProvider).value;

          scaffoldMessenger.clearSnackBars(); // Usuwamy napis "Szukam..."

          if (scannedProduct != null) {
            ref
                .read(calcInDialogProvider.notifier)
                .recalculate(scannedProduct, weightController);
          } else {
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Nie znaleziono produktu w bazie.')),
            );
          }
        }
      },
      icon: Icon(
        Icons.qr_code_scanner,
        color: barcodeState == null
            ? Colors.limeAccent
            : Colors.lightGreenAccent,
      ),
      tooltip: "Zeskanuj kod",
    );
  }
}
