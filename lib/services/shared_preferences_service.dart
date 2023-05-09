import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> loadProducts() async {
    final SharedPreferences prefs = await _prefs;
    final String? productsJson = prefs.getString('products');
    if (productsJson != null) {
      final List<dynamic> productsList = json.decode(productsJson);
      return productsList.map((product) => Map<String, dynamic>.from(product)).toList();
    }
    return [];
  }

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final SharedPreferences prefs = await _prefs;
    final String productsJson = json.encode(products);
    await prefs.setString('products', productsJson);
  }
}
