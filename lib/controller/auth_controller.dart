import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/session.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/utils/storage.dart';

class AuthController extends AsyncNotifier<Session?> {
  @override
  Future<Session?> build() async {
    final storage = ref.watch(storageProvider);
    final refreshToken = await storage.read('refreshToken');

    if (refreshToken != null) {
      // Fetch and store a new one
      return await ref.read(authRepositoryProvider).refreshToken(refreshToken);
    } else {
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        ref.read(authRepositoryProvider).signInWithGoogle);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(authRepositoryProvider).signOut);
  }

  Future<void> refreshToken(String refreshToken) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).refreshToken(refreshToken));
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, Session?>(AuthController.new);
