import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/evidence_rating.dart';
import 'package:skripsi_mobile/repositories/evidence_rating_repository.dart';

class EvidenceRatingController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  Future<void> addContainerRating(PayloadEvidenceRating rating) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () =>
          ref.read(evidenceRatingRepositoryProvider).addContainerRating(rating),
    );
  }

  Future<void> deleteContainerRating(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
        ref.read(evidenceRatingRepositoryProvider).deleteContainerRating(id));
  }
}

final evidenceRatingControllerProvider =
    AutoDisposeAsyncNotifierProvider<EvidenceRatingController, void>(
        EvidenceRatingController.new);
