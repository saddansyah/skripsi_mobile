import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        ref.read(authRepositoryProvider).signInWithGoogle);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(authRepositoryProvider).signOut);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
