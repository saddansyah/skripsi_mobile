import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/screens/models/user.dart';
import 'package:skripsi_mobile/utils/interceptor.dart';

class ProfileRepository {
  final Dio fetcher;

  ProfileRepository(this.fetcher);

  Future<User> getMyProfile() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/my');

      return User.fromMap(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat pada server';
      }
    }
  }
}

final profileRepositoryProvider =
    Provider.autoDispose<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(dioProvider));
});

final profileProvider = FutureProvider.autoDispose<User>((ref) async {
  final link = ref.keepAlive();
  final cancelToken = CancelToken();

  final profileRepository = ref.watch(profileRepositoryProvider);
  User user = await profileRepository.getMyProfile();

  ref.onDispose(() {
    link.close();
    cancelToken.cancel();
  });


  return user;
});
