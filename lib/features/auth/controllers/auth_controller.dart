import 'package:cura_frontend/features/auth/repository/auth_repository.dart';
import 'package:cura_frontend/features/community/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository, ref);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController(this.authRepository, this.ref);

  void signInWithPhone(showProgress, BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(showProgress, context, phoneNumber);
  }

  void verifyOTP(showProgress, BuildContext context, String verificationId,
      String userOTP, WidgetRef ref) {
    authRepository.verifyOTP(
        showProgress, context, verificationId, userOTP, ref);
  }
}
