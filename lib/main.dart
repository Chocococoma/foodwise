import 'package:flutter/material.dart';
import 'package:foodwise/screens/products_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodwise/models/product_data.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProductData(),
      child: MaterialApp(
        home: ProductsScreen(),
      ),
    );
  }
}