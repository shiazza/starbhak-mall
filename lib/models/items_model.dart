class Item {
  final int id;
  final DateTime createdAt;
  final String name;
  final String description;
  final int price;
  final int ratings;
  final String category;
  final int idCreator;
  final String? media;
  final String type;

  Item({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.price,
    required this.ratings,
    required this.category,
    required this.idCreator,
    this.media,
    required this.type,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      name: map['name'],
      description: map['description'],
      price: map['price'],
      ratings: map['ratings'],
      category: map['category'],
      idCreator: map['id_creator'],
      media: map['media'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'description': description,
      'price': price,
      'ratings': ratings,
      'category': category,
      'id_creator': idCreator,
      'media': media,
      'type': type,
    };
  }
}