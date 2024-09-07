class User {
  User({
    required this.id,
    required this.issuer,
    required this.subject,
    required this.lastSignInAt,
    required this.email,
    required this.name,
    required this.fullname,
    required this.avatarUrl,
    required this.isAdmin,
    required this.totalPoint,
    required this.rank,
    required this.nextRank,
    required this.nextPoint,
  });

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
  final String nextRank;
  final int nextPoint;

  factory User.fromMap(Map<String, dynamic> json) {
    final rawUserMetaData = json['raw_user_meta_data'];

    return User(
      id: json['id'],
      issuer: rawUserMetaData['iss'],
      subject: rawUserMetaData['sub'],
      lastSignInAt: json['last_sign_in_at'],
      email: rawUserMetaData['email'],
      name: rawUserMetaData['name'],
      fullname: rawUserMetaData['full_name'],
      avatarUrl: rawUserMetaData['avatar_url'],
      isAdmin: json['is_admin'],
      totalPoint: json['total_point'],
      rank: json['current_rank'],
      nextPoint: json['current_max_point'],
      nextRank: json['next_rank'],
    );
  }
}

class LeaderboardUser {
  final String id;
  final String name;
  final String img;
  final int totalPoint;
  final String rank;
  final int rankNumber;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.img,
    required this.totalPoint,
    required this.rank,
    required this.rankNumber,
  });

  factory LeaderboardUser.fromMap(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      totalPoint: json['total_point'],
      rank: json['current_rank'],
      rankNumber: json['rank_number'],
    );
  }
}
