class ProductModel {
  String id;
  String name;
  String details;
  String price;
  String pictureLink;
  DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.details,
    required this.price,
    required this.pictureLink,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'price': price,
      'pictureLink': pictureLink,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      details: map['details'],
      price: map['price'],
      pictureLink: map['pictureLink'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
