class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? email;
  final String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email,
    this.token,
  });

  String get name => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'token': token,
    };
  }
}
