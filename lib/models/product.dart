class Product {
  final int? id;
  final String name;
  final double price;
  final String category;
  final String imagePath;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'image_path': imagePath,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
      imagePath: map['image_path'],
    );
  }
}