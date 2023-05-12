import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:FoodWise/models/product.dart';


class ProductData extends ChangeNotifier {
  List<Product> _products = [];

  UnmodifiableListView<Product> get products {
    _sortProducts();
    return UnmodifiableListView(_products);
  }

  int get productCount {
    return _products.length;
  }

  void _sortProducts() {
    _products.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
  }

  int _nextProductId = 1;

  Future<void> loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList('products') ?? [];
    _products = productsJson
        .map((productJson) => Product.fromJson(json.decode(productJson)))
        .toList();
    _nextProductId = _products.isNotEmpty
        ? int.parse(_products.last.id) + 1
        : 1; // set the next product id based on the last product's id
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    _nextProductId++; // increment the ID for the next product
    _saveProducts();
    notifyListeners();
  }

  void updateProduct(Product product) {
    product.isDone = !product.isDone;
    _saveProducts();
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
    _saveProducts();
    notifyListeners();
  }

  void _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson =
    _products.map((product) => json.encode(product.toJson())).toList();
    await prefs.setStringList('products', productsJson);
  }
}

Future<void> saveProduct(String scannedData, String productName, DateTime expirationDate) async {
  try {
    final jsonData = jsonDecode(scannedData);
    if (jsonData is List && jsonData.isNotEmpty) {
      final productData = jsonData[0];
      final product = Product.fromJson(productData);
      product.name = productName;
      product.expirationDate = expirationDate;
      await _saveProduct(product);
    } else {
      final product = Product(name: productName, expirationDate: expirationDate);
      await _saveProduct(product);
    }
  } catch (e) {
    throw Exception('Failed to save product: $e');
  }
}

Future<void> _saveProduct(Product product) async {
  final box = await Hive.openBox<Product>('productsBox');
  await box.put(product.id, product);
}
