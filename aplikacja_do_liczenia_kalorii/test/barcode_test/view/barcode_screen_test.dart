import 'package:aplikacja_do_liczenia_kalorii/modules/barcode/view/barcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  testWidgets('Powinien zamknąć ekran i zwrócić kod po wykryciu kodu kreskowego', (tester) async {
    String? returnedCode;

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () async {
            returnedCode = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
            );
          },
          child: const Text('Otwórz skaner'),
        );
      }),
    ));

    await tester.tap(find.text('Otwórz skaner'));
    await tester.pumpAndSettle();

    final scannerFinder = find.byType(MobileScanner);
    expect(scannerFinder, findsOneWidget);

    final MobileScanner scannerWidget = tester.widget(scannerFinder);
    
    final mockCapture = BarcodeCapture(
      barcodes: [
        Barcode(rawValue: '123456789'),
      ],
    );

    scannerWidget.onDetect!(mockCapture);

    await tester.pumpAndSettle();

    expect(returnedCode, '123456789');
    expect(find.byType(BarcodeScannerScreen), findsNothing);
  });

  testWidgets('Powinien zignorować drugie wykrycie kodu (zabezpieczenie _isScanned)', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BarcodeScannerScreen(),
    ));

    final MobileScanner scannerWidget = tester.widget(find.byType(MobileScanner));
    
    final mockCapture = BarcodeCapture(barcodes: [Barcode(rawValue: 'A')]);
    final mockCapture2 = BarcodeCapture(barcodes: [Barcode(rawValue: 'B')]);

    scannerWidget.onDetect!(mockCapture);
    scannerWidget.onDetect!(mockCapture2);

    await tester.pumpAndSettle();

    expect(find.byType(BarcodeScannerScreen), findsNothing);
  });
}