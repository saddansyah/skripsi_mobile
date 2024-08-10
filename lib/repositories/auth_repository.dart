import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:skripsi_mobile/screens/models/session.dart';
import 'package:skripsi_mobile/utils/interceptor.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Stream<Session?> authStateChange();
}

class HttpAuthRepository implements AuthRepository {
  final Dio fetcher;

  HttpAuthRepository(this.fetcher);

  static const webClientId =
      '976890805296-j9d4ieps164g26ligdtg4rvia6g8fblb.apps.googleusercontent.com';
  static const iosClientId =
      '976890805296-1l7fb5co39jhpiobgmv0e9esvrtifbl1.apps.googleusercontent.com';

  @override
  Future<void> signInWithGoogle() async {
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

    await fetcher.post('${Api.baseUrl}/auth/signin/google',
        data: FormData.fromMap(
          {
            'idToken': idToken,
            'accessToken': accessToken,
          },
        ));
  }

  @override
  Future<void> signOut() async {
    await fetcher.post('${Api.baseUrl}/auth/signout');
  }

  @override
  Stream<Session?> authStateChange() async* {
    Response<ResponseBody> rs = await Dio().get<ResponseBody>(
      '${Api.baseUrl}/auth/state',
      options: Options(headers: {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      }, responseType: ResponseType.stream), // set responseType to `stream`
    );

    StreamTransformer<Uint8List, List<int>> unit8Transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );

    final Stream<Session?> sessionStream = rs.data!.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .where((s) => s.startsWith('data'))
        .map((s) => s.substring(6))
        .map((s) => jsonDecode(s))
        .map((s) {
      print(s);
      return s['data'] == null ? null : Session.fromMap(s['data']);
    });

    await for (final session in sessionStream) {
      yield session;
    }
  }
}

// Repository Provider
final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return HttpAuthRepository(Dio());
});

// Stream Provider -> for watching authStateChange
final sessionProvider = StreamProvider.autoDispose<Session?>((ref) {
  // IMPORTANT -> keepAlive() maintain state to be listened everytime
  ref.keepAlive();

  return ref.watch(authRepositoryProvider).authStateChange();
});
