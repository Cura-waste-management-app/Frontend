import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/debug_print.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final firebaseIdTokenProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(firebaseUserProvider).value;
  prints("user $user");
  if (user != null) {
    return await user.getIdToken();
  }
  return null;
});
