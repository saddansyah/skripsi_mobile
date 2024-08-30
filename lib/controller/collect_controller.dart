import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/models/collect.dart';

class CollectController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  Future<void> addMyCollect(PayloadCollect collect, File localImageFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref
        .read(collectRepositoryProvider)
        .addMyCollect(collect, localImageFile));
  }

  Future<void> deleteMyCollect(int id, String img) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(collectRepositoryProvider).deleteMyCollect(id, img));
  }
}

final collectControllerProvider =
    AutoDisposeAsyncNotifierProvider<CollectController, void>(
        CollectController.new);
