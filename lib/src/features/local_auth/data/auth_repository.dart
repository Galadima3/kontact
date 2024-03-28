import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationRepository {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      log(e.toString());
      return false;
    }
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      return availableBiometrics;
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      log(e.toString());
      log('b');
    }
    return availableBiometrics;
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      log(e.toString());

      return false;
    }
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
  }
}

final authProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepository();
});
