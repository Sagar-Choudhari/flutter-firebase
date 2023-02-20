class User {
  String? id;
  late final String name;
  late final String email;
  late final String number;
  late final String password;

  User({
    this.id = '',
    required this.name,
    required this.email,
    required this.number,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'number': number,
        'password': password,
      };
  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        number: json['number'] ?? '',
        password: json['password'] ?? '',
      );
}
