
class Comment {
  final int id;
  final DateTime createdAt;
  final int idItems;
  final int idUser;
  final String text;
  final int ratings;
  final int thumbsUp;
  final String? media;
  final int? idComments;

  var user;

  Comment({
    required this.id,
    required this.createdAt,
    required this.idItems,
    required this.idUser,
    required this.text,
    required this.ratings,
    required this.thumbsUp,
    this.media,
    this.idComments,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      idItems: map['id_items'],
      idUser: map['id_user'],
      text: map['text'],
      ratings: map['ratings'],
      thumbsUp: map['thumbs_up'],
      media: map['media'],
      idComments: map['id_comments'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'id_items': idItems,
      'id_user': idUser,
      'text': text,
      'ratings': ratings,
      'thumbs_up': thumbsUp,
      'media': media,
      'id_comments': idComments,
    };
  }
}

