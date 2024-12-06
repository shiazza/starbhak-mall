class Cart {
  final int id;
  final int idItems;
  final int idUser;
  final int qty;

  Cart({
    required this.id,
    required this.idItems,
    required this.idUser,
    required this.qty,
  });

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'],
      idItems: map['id_items'],
      idUser: map['id_user'],
      qty: map['qty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_items': idItems,
      'id_user': idUser,
      'qty': qty,
    };
  }
}
