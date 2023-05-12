import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:FoodWise/models/product.dart';
import 'package:FoodWise/models/product_data.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final productsJson = jsonDecode(scanData.code ?? '');
      if (productsJson is List && productsJson.isNotEmpty) {
        final productData = Provider.of<ProductData>(context, listen: false);
        for (final productJson in productsJson) {
          final productName = productJson['name'];
          final expirationDateString = productJson['expirationDate'];
          final expirationDate = expirationDateString != null
              ? DateFormat('MM/dd/yyyy').parse(expirationDateString)
              : null;
          if (productName != null && expirationDate != null) {
            final product = Product(
              name: productName,
              expirationDate: expirationDate,
            );
            if (!productData.products.any((p) =>
            p.name == product.name &&
                p.expirationDate == product.expirationDate)) {
              productData.addProduct(product);
            }
          }
        }
      }

      Navigator.pushReplacementNamed(context, '/');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.green),
              SizedBox(width: 8),
              Text('Scanned QR code'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Products are now in the Productlist"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );

    });
  }
}
