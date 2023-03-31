class UserModel {
  String id;
  String name;
  String phone;
  String email;
  String password;
  String token;
  String address;
  bool active;
  DateTime lastSeen;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.token,
    required this.address,
    required this.active,
    required this.lastSeen,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'token': token,
      'address': address,
      'active': active,
      'last_seen': lastSeen,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
      address: map['address'],
      active: map['active'],
      lastSeen: DateTime.parse(map['last_seen']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
