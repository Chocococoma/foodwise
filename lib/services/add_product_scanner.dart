import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:FoodWise/models/product_data.dart';
import 'package:FoodWise/models/product.dart';
import 'package:intl/intl.dart';





class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final productsJson = jsonDecode(scanData.code ?? '');
      if (productsJson is List && productsJson.isNotEmpty) {
        final firstProductJson = productsJson.first;
        final productName = firstProductJson['name'];
        final expirationDateString = firstProductJson['expirationDate'];
        final expirationDate = expirationDateString != null
            ? DateFormat('MM/dd/yyyy').parse(expirationDateString)
            : null;
        final product = Product(
          name: productName ?? "",
          expirationDate: expirationDate ?? DateTime.now(),
        );
        final productData = Provider.of<ProductData>(context, listen: false);
        productData.addProduct(product);
      }

      Navigator.pushReplacementNamed(context, '/');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Scanned QR code'),
          content: Text(scanData.code ?? ""),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product name',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Expiration date:'),
              SizedBox(height: 8.0),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: selectedDate == null
                      ? Text(
                    'Tap to select a date',
                    style: TextStyle(color: Colors.grey),
                  )
                      : Text(
                    DateFormat.yMMMMd().format(selectedDate!),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final product = Product(
                  name: nameController.text.trim(),
                  expirationDate: selectedDate ?? DateTime.now().add(Duration(days: 7)),
                );
                final productData = Provider.of<ProductData>(context, listen: false);
                productData.addProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

