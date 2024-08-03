import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skripsi_mobile/screens/models/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session, User;

abstract class AuthRepository {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Stream<Session?> authStateChange();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this.supabase);
  final SupabaseClient supabase;

  static const webClientId =
      '976890805296-j9d4ieps164g26ligdtg4rvia6g8fblb.apps.googleusercontent.com';
  static const iosClientId =
      '976890805296-1l7fb5co39jhpiobgmv0e9esvrtifbl1.apps.googleusercontent.com';

  @override
  Stream<Session?> authStateChange() {
    return supabase.auth.onAuthStateChange.map((data) {
      if (data.session != null) {
        return Session(
          accessToken: data.session!.accessToken,
          refreshToken: data.session!.refreshToken!,
        );
      }
      return null;
    });
  }

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

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
});

// Stream Provider -> for watching authStateChange
final sessionProvider = StreamProvider.autoDispose<Session?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChange();
});
