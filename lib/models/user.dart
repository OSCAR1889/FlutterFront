class User {
  int id;
  String username;
  String email;
  String password;
  String? url;
  String? fullName;
  DateTime? birthDate;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.url,
    this.fullName,
    this.birthDate,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      url: json['url'],
      fullName: json['fullName'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'url': url,
      'fullName': fullName,
      'birthDate': birthDate?.toIso8601String(),
    };
  }
}
