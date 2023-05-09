class Product {
  String id;
  String name;
  DateTime expirationDate;
  bool isDone;

  Product({
    required this.id,
    required this.name,
    required this.expirationDate,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'expirationDate': expirationDate.toIso8601String(),
      'isDone': isDone,
    };
  }
}
