class DailySignInStatus {
  final DateTime createdAt;
  final DateTime nextDate;

  DailySignInStatus({required this.createdAt, required this.nextDate});

  factory DailySignInStatus.fromMap(Map<String, dynamic> json) {
    return DailySignInStatus(
      createdAt: DateTime.parse(json['created_at']),
      nextDate: DateTime.parse(json['next_date']),
    );
  }
}

class DailySignInStreak {
  final int weeklyStreakCount;
  final int weeklyStreakRemaining;

  DailySignInStreak({
    required this.weeklyStreakCount,
    required this.weeklyStreakRemaining,
  });

  factory DailySignInStreak.fromMap(Map<String, dynamic> json) {
    return DailySignInStreak(
      weeklyStreakCount: json['weekly_streak_count'],
      weeklyStreakRemaining: json['weekly_streak_remaining'],
    );
  }
}
