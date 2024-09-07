import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/daily_sign_in_repository.dart';

class DailySignInController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  Future<void> claimDailySignInStatus() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(dailySignInRepositoryProvider).claimDailySignInStatus(),
    );
  }

  Future<void> claimDailySignInStreak() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(dailySignInRepositoryProvider).claimDailySignInStreak());
  }
}

final dailySignInControllerProvider =
    AutoDisposeAsyncNotifierProvider<DailySignInController, void>(
        DailySignInController.new);
