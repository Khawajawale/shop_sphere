import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/auth/user_role.dart';
import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.phone,
    super.photoUrl,
    required super.emailVerified,
    required super.createdAt,
    super.role,
  });

  /// Create a UserModel from Firestore document
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return UserModel(
      uid: document.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      emailVerified: data['emailVerified'] ?? false,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
      role: UserRole.fromString(data['role'] as String?),
    );
  }

  /// Convert UserModel to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'role': role.value,
    };
  }

  /// Create a modified copy
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    bool? emailVerified,
    DateTime? createdAt,
    UserRole? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified:
          emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
    );
  }
}