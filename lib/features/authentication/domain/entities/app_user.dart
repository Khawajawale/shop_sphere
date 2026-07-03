class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.emailVerified,
    required this.createdAt,
  });
}