class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, email, phone, createdAt, updatedAt);
  }
}
