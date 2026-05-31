enum UserRole { customer, admin, seller }

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final UserRole role;
  final String? avatar;
  final String? address;
  final DateTime createdAt;
  bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.role = UserRole.customer,
    this.avatar,
    this.address,
    required this.createdAt,
    this.isVerified = false,
  });

  User copyWith({
    String? name,
    String? phone,
    String? avatar,
    String? address,
    bool? isVerified,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email,
      password: password,
      phone: phone ?? this.phone,
      role: role,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      createdAt: createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
