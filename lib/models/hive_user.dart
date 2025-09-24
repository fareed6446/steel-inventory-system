import 'package:hive/hive.dart';

part 'hive_user.g.dart';

@HiveType(typeId: 0)
class HiveUser extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String name;

  @HiveField(3)
  String role;

  @HiveField(4)
  String? phone;

  @HiveField(5)
  String? department;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  @HiveField(8)
  bool isActive;

  @HiveField(9)
  String? profileImageUrl;

  @HiveField(10)
  Map<String, dynamic>? preferences;

  HiveUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.department,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.profileImageUrl,
    this.preferences,
  });

  // Factory constructor for creating from Supabase user data
  factory HiveUser.fromSupabase({
    required String id,
    required String email,
    required String name,
    required String role,
    String? phone,
    String? department,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isActive = true,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
  }) {
    final now = DateTime.now();
    return HiveUser(
      id: id,
      email: email,
      name: name,
      role: role,
      phone: phone,
      department: department,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      isActive: isActive,
      profileImageUrl: profileImageUrl,
      preferences: preferences,
    );
  }

  // Convert to Map for Supabase operations
  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'phone': phone,
      'department': department,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'profile_image_url': profileImageUrl,
      'preferences': preferences,
    };
  }

  // Copy with method for updates
  HiveUser copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? phone,
    String? department,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
  }) {
    return HiveUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
    );
  }

  // Update timestamp
  HiveUser updateTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  // Check if user is admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  // Check if user is manager
  bool get isManager => role.toLowerCase() == 'manager';

  // Check if user is operator
  bool get isOperator => role.toLowerCase() == 'operator';

  // Get display name
  String get displayName => name.isNotEmpty ? name : email.split('@')[0];

  // Get role display name
  String get roleDisplayName {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'manager':
        return 'Manager';
      case 'operator':
        return 'Operator';
      default:
        return role;
    }
  }

  @override
  String toString() {
    return 'HiveUser(id: $id, email: $email, name: $name, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HiveUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
