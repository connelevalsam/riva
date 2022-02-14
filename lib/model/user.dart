class User {
  int id;
  String phone;
  String password;
  List profile;

  User({
    required this.id,
    required this.phone,
    required this.password,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "",
      password: json["password"] ?? '',
      phone: json["phone"] ?? '',
      profile: json["profile"] ?? [],
    );
  }
}
