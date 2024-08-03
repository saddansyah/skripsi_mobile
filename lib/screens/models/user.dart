class User {
  User(
      {required this.id,
      required this.issuer,
      required this.subject,
      required this.lastSignInAt,
      required this.email,
      required this.name,
      required this.fullname,
      required this.avatarUrl,
      required this.isAdmin,
      required this.totalPoint,
      required this.rank});

  final String id;
  final String issuer;
  final String subject;
  final String lastSignInAt;
  final String email;
  final String name;
  final String fullname;
  final String avatarUrl;
  final bool isAdmin;
  final num totalPoint;
  final String rank;
}
