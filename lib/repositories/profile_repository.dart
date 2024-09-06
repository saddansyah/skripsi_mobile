import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/utils/api.dart';
import 'package:skripsi_mobile/utils/storage.dart';

abstract class ProfileRepository {
  Future<User> getMyProfile(CancelToken cancelToken);
}

class ProfileDioRepository implements ProfileRepository {
  final Dio fetcher;
  final BaseStorage storage;

  ProfileDioRepository(this.fetcher, this.storage);

  @override
  Future<User> getMyProfile(CancelToken cancelToken) async {
    try {
      final response =
          await fetcher.get('${Api.baseUrl}/my', cancelToken: cancelToken);

      storage.write(
          'profile', jsonEncode(response.data as Map<String, dynamic>));

      final user = User.fromMap(response.data['data'][0]);

      // Subscribing notification channel with user id
      OneSignal.login(user.id);

      return user;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
    catch(e){
      rethrow;
    }
  }
}

final profileRepositoryProvider = Provider<ProfileDioRepository>((ref) {
  return ProfileDioRepository(
      ref.watch(dioProvider), ref.watch(storageProvider));
});

final profileProvider = FutureProvider<User>((ref) async {
  final cancelToken = CancelToken();

  final profileRepository = ref.watch(profileRepositoryProvider);
  User user = await profileRepository.getMyProfile(cancelToken);

  ref.onDispose(() {
    cancelToken.cancel();
  });

  return user;
});

final profileFromStorageProvider = FutureProvider.autoDispose((ref) async {
  final storage = ref.watch(storageProvider);
  final userFromStorage = await storage.read('profile');

  if (userFromStorage == null) {
    return null;
  }
  return User.fromMap(jsonDecode(userFromStorage));
});
