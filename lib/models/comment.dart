class Comment {
  final int id;
  final String content;
  final int userId;
  final int topperId;
  final DateTime createdAt;
  String? username;

  Comment({
    required this.id,
    required this.content,
    required this.userId,
    required this.topperId,
    required this.createdAt,
    this.username
  });

  factory Comment.fromJSON(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      userId: json['userId'],
      topperId: json['topperId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'topperId': topperId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
