import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontacts/src/features/local_auth/data/auth_repository.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
// Import your AuthenticationRepository class

class AuthenticationController extends StateNotifier<AsyncValue<bool>> {
  final AuthenticationRepository _authRepository;

  AuthenticationController(this._authRepository)
      : super(const AsyncData<bool>(false));

  Future<void> authenticateWithBiometrics() async {
    try {
      state = const AsyncLoading();
      bool authenticated = await _authRepository.authenticateWithBiometrics();
      state = AsyncData(authenticated);
    } on PlatformException catch (e) {
      String errorMessage;
      if (e.code == auth_error.notAvailable) {
        errorMessage = 'No biometric sensor detected on this device.';
      } else if (e.code == auth_error.notEnrolled) {
        errorMessage = 'No fingerprint or face ID is enrolled on this device.';
      } else {
        errorMessage =
            'An error occurred during authentication.'; // Generic error for others
      }
      state = AsyncError(errorMessage, StackTrace.current);
    }
  }
}

final authenticationControllerProvider =
    StateNotifierProvider<AuthenticationController, AsyncValue<bool>>((ref) {
  final authRepository = ref.watch(authProvider);
  return AuthenticationController(authRepository);
});
