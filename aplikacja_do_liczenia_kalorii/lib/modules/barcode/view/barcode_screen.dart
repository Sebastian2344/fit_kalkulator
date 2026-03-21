import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isScanned = false; // Zapobiega wielokrotnemu Navigator.pop()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zeskanuj kod')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isScanned) return; // Jeśli już złapało kod, ignoruj kolejne klatki z aparatu

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            _isScanned = true; // Zabezpieczenie przed drugim wejściem
            final code = barcodes.first.rawValue!;
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}