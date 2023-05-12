import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:hive/hive.dart';
import 'package:FoodWise/models/product.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:FoodWise/screens/products_screen.dart';
import 'package:flutter/material.dart';



DateTime dateTime = DateTime.now();
TZDateTime tzDateTime = TZDateTime.utc(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
Location location = getLocation('Europe/London');


//TODO works not everywhere
class ProductData extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> scheduleExpiryNotification(
      int id,
      DateTime expirationDate,
      ) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidNotificationDetails(
      'expiry_channel',
      'Expiry notifications',
      'Notifications for expiring products',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOS = IOSNotificationDetails();
    const notificationDetails = NotificationDetails(android: android, iOS: iOS);

    final timeUntilExpiry = expirationDate.difference(DateTime.now());
    if (timeUntilExpiry.inDays < 2 && timeUntilExpiry.inDays >= 0) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Product $id is expiring soon',
        'The expiry date is ${expirationDate.toIso8601String()}',
        notificationDetails,
      );
    }
  }


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
    _saveProduct(product);
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
  final prefs = await SharedPreferences.getInstance();
  final productsJson = prefs.getString('products');
  List<dynamic> productsList = productsJson != null ? jsonDecode(productsJson) : [];
  productsList.add(product.toJson());
  prefs.setString('products', jsonEncode(productsList));
}
