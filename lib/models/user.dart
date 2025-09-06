class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // 'poster' or 'seeker'
  final String? profileImageUrl;
  final String? location;
  final DateTime createdAt;
  final bool isPremium;
  final DateTime? premiumExpiry;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImageUrl,
    this.location,
    required this.createdAt,
    this.isPremium = false,
    this.premiumExpiry,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      profileImageUrl: map['profileImageUrl'],
      location: map['location'],
      createdAt: DateTime.parse(map['createdAt']),
      isPremium: map['isPremium'] ?? false,
      premiumExpiry: map['premiumExpiry'] != null ? DateTime.parse(map['premiumExpiry']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'isPremium': isPremium,
      'premiumExpiry': premiumExpiry?.toIso8601String(),
    };
  }
}