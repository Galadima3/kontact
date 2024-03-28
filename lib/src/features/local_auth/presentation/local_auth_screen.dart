// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kontacts/src/features/local_auth/data/auth_repository.dart';
import 'package:kontacts/src/features/local_auth/presentation/fingerprint_bottom_sheet.dart';
import 'package:kontacts/src/features/local_auth/presentation/fingerprint_controller.dart';
import 'dart:developer';
// Import your AuthenticationRepository class

class LocalAuthScreen extends ConsumerWidget {
  const LocalAuthScreen({super.key});

  Future<void> onFingerprintButtonPressed(
      WidgetRef ref, BuildContext context) async {
    final state = ref.watch(authenticationControllerProvider);
    if (!state.isLoading) {
      final notifier = ref.read(authenticationControllerProvider.notifier);
      final biomtericTypes =
          await AuthenticationRepository().getAvailableBiometrics();
      log("Bio +$biomtericTypes");
      if (biomtericTypes.isNotEmpty) {
        await showModalBottomSheet(
          context: context,
          builder: (context) => const FingerprintBottomSheet(),
        );
        notifier.authenticateWithBiometrics();
      } else {
        // Handle no biometrics case (e.g., show error message)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('This device does not contain biometric sensors')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authenticationControllerProvider);

    //TODO:fix this issue
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome. Tap to login with Fingerprint sensor'),
            GestureDetector(
              onTap: state.isLoading
                  ? null
                  : () => onFingerprintButtonPressed(ref, context),
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : SvgPicture.asset(
                      'assets/images/fingerprint.svg',
                      height: 100,
                      width: 100,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
