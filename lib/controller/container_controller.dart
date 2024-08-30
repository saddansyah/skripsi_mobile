import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/container.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';

class ContainerController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  Future<void> addContainer(PayloadContainer container) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(containerRepositoryProvider).addContainer(container),
    );
  }

  Future<void> updateContainer(PayloadContainer container, int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
        ref.read(containerRepositoryProvider).updateContainer(container, id));
  }

  Future<void> deleteContainer(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(containerRepositoryProvider).deleteContainer(id));
  }
}

final containerControllerProvider =
    AutoDisposeAsyncNotifierProvider<ContainerController, void>(
        ContainerController.new);
