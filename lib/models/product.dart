import 'package:uuid/uuid.dart';

class Product {


  String id;
  String name;
  DateTime expirationDate;
  bool isDone;

  Product({
    required this.name,
    String? id,
    required this.expirationDate,
    this.isDone = false,
  }) : id = id ?? Uuid().v4();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    expirationDate: DateTime.parse(json['expirationDate']),
    isDone: json['isDone'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'expirationDate': expirationDate.toIso8601String(),
    'isDone': isDone,
  };

}
