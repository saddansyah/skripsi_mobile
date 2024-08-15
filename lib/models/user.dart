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
  final String? lastSignInAt;
  final String email;
  final String name;
  final String fullname;
  final String avatarUrl;
  final bool? isAdmin;
  final int totalPoint;
  final String rank;

  factory User.fromMap(Map<String, dynamic> json) {

    final data = json['data'][0];
    final rawUserMetaData = data['raw_user_meta_data'];

    return User(
      id: data['id'],
      issuer: rawUserMetaData['iss'],
      subject: rawUserMetaData['sub'],
      lastSignInAt: data['last_sign_in_at'] ?? '',
      email: rawUserMetaData['email'],
      name: rawUserMetaData['name'],
      fullname: rawUserMetaData['full_name'],
      avatarUrl: rawUserMetaData['avatar_url'],
      isAdmin: data['is_admin'] ?? '',
      totalPoint: data['total_points'],
      rank: data['rank'],
    );
  }
}
