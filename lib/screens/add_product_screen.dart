import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FoodWise/models/product.dart';
import 'package:FoodWise/models/product_data.dart';

class AddProductScreen extends StatefulWidget {
  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  late String newProductTitle;
  DateTime? expirationDate = DateTime.now(); // or null
  bool isFromQRScan = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Product',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newProductTitle = newText;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFB6EBD0),
                elevation: 5.0,
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                if (newProductTitle.isNotEmpty) {
                  final newProduct = Product(
                    name: newProductTitle,
                    expirationDate: expirationDate ?? DateTime.now(),
                    isDone: isFromQRScan,
                  );
                  Provider.of<ProductData>(context, listen: false)
                      .addProduct(newProduct);
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Expiration Date:',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                TextButton(
                  child: Text(
                    expirationDate == null
                        ? 'Choose Date'
                        : '${expirationDate!.year}-${expirationDate!.month}-${expirationDate!.day}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (pickedDate != null) {
                      setState(() {
                        expirationDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
