import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:skripsi_mobile/models/session.dart';
import 'package:skripsi_mobile/utils/api.dart';
import 'package:skripsi_mobile/utils/storage.dart';

abstract class AuthRepository {
  Future<Session?> signInWithGoogle();
  Future<Session?> signOut();
  Future<Session?> refreshToken(String refreshToken);
}

class HttpAuthRepository implements AuthRepository {
  final Dio fetcher;
  final BaseStorage storage;

  HttpAuthRepository(this.fetcher, this.storage);

  static const webClientId =
      '976890805296-j9d4ieps164g26ligdtg4rvia6g8fblb.apps.googleusercontent.com';
  static const iosClientId =
      '976890805296-1l7fb5co39jhpiobgmv0e9esvrtifbl1.apps.googleusercontent.com';

  @override
  Future<Session?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final accessToken = googleAuth?.accessToken;
      final idToken = googleAuth?.idToken;

      if (accessToken == null && idToken == null) {
        throw 'Sign In Failed, Try Again';
      }

      if (accessToken == null) {
        throw 'No Access Token found';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      final response = await fetcher.post(
        '${Api.baseUrl}/auth/signin/google',
        data: FormData.fromMap(
          {
            'idToken': idToken,
            'accessToken': accessToken,
          },
        ),
      );

      final session = Session.fromMap(response.data['data'][0]);
      storage.write('refreshToken', session.refreshToken);

      print('Token is refrshed!');
      return session;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat pada signin (${e.response?.statusCode})';
      }
    } catch (e) {
      throw 'Terjadi galat pada signin. Coba lagi.';
    }
  }

  @override
  Future<Session?> signOut() async {
    try {
      await fetcher.post('${Api.baseUrl}/auth/signout');
      storage.delete('refreshToken');
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat pada saat signout (${e.response?.statusCode})';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Session?> refreshToken(String refreshToken) async {
    try {
      final response = await fetcher.post(
        '${Api.baseUrl}/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final session = Session.fromMap(response.data['data'][0]);
      storage.write('refreshToken', session.refreshToken);
      return session;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat saat melakukan refresh token (${e.response?.statusCode})';
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Repository Provider
final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return HttpAuthRepository(
    Dio(Api.dioOptions),
    ref.watch(storageProvider),
  );
});
