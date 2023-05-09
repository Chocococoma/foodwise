import 'package:flutter/foundation.dart';
import 'package:foodwise/models/product.dart';
import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//TODO
// 1. Daten in cache speichern 2. Kamera scanner (QR Code), 3. Notification aka. alarm,
// wenn ein Produkt rot ist 4. Alarm einstellen (wann soll ein Alarm gesendet werden,
// weniger als 2 tage oder 3 tage ? etc
class ProductData extends ChangeNotifier {
  void _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = [];
    for (Product product in _products) {
      productsJson.add(json.encode(product.toJson()));
    }
    await prefs.setStringList('products', productsJson);
  }

  List<Product> _products = [
    //Product(id: '1', name: 'milk', expirationDate: DateTime.now().add(Duration(days: 7))),
    //Product(id: '2', name: 'eggs', expirationDate: DateTime.now().add(Duration(days: 4))),
    //Product(id: '3', name: 'bread', expirationDate: DateTime.now().add(Duration(days: 1))),
  ];


  UnmodifiableListView<Product> get products {
    return UnmodifiableListView(_products);
  }

  int get productCount {
    return _products.length;
  }

  int _nextProductId = 1;

  void addProduct(String newProductName, DateTime selectedDate) {
    final product = Product(
        id: _nextProductId.toString(),
        name: newProductName,
        expirationDate: selectedDate);
    _products.add(product);
    _nextProductId++; // increment the ID for the next product
    notifyListeners();
  }

  void updateProduct(Product product) {
    product.isDone = !product.isDone;
    notifyListeners();
  }

  void updateProductById(String id, String name, DateTime expirationDate) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      final updatedProduct =
      Product(name: name, expirationDate: expirationDate, id: id);
      _products[index] = updatedProduct;
      _saveProducts();
      notifyListeners();
    }
  }

  void deleteProductById(String id) {
    _products.removeWhere((product) => product.id == id);
    _saveProducts();
    notifyListeners();
  }


  void deleteProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void _saveChanges(Product updatedProduct) {
    int index = _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index >= 0) {
      _products[index].name = updatedProduct.name;
      _products[index].expirationDate = updatedProduct.expirationDate;
      _saveProducts();
    }
  }
}


