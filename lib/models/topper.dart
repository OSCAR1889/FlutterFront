class Topper {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final int userId;
  final int categoryId;
  final DateTime createdAt;

  Topper({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.userId,
    required this.categoryId,
    required this.createdAt,
  });

  factory Topper.fromJSON(Map<String, dynamic> json) {
    return Topper(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }


  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
