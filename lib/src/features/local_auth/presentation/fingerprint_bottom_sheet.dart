import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kontacts/src/features/local_auth/data/auth_repository.dart';
import 'package:kontacts/src/routing/route_paths.dart';

class FingerprintBottomSheet extends StatefulWidget {
  const FingerprintBottomSheet({super.key});

  @override
  State<FingerprintBottomSheet> createState() => _FingerprintBottomSheetState();
}

class _FingerprintBottomSheetState extends State<FingerprintBottomSheet> {
  //String _message = "Please enter your fingerprint";
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _authenticate(context);
  }

  Future<void> _authenticate(BuildContext context) async {
    setState(() {
      // _message = "Authenticating...";
      _isAuthenticating = true;
    });

    final authenticated = await AuthenticationRepository().authenticate();

    setState(() {
      //_message = authenticated ? "Success!" : "Failed";
      _isAuthenticating = false;
    });

    if (authenticated) {
      // Redirect to another page after successful validation
      // ignore: use_build_context_synchronously
      context.pushReplacementNamed(RoutePaths
          .homeScreenRoute); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // Center(
        //   child: Text(
        //     _message,
        //     style: const TextStyle(fontSize: 20),
        //   ),
        // ),
        _isAuthenticating
            ? const LinearProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.fingerprint),
                onPressed: () => _authenticate(context),
              ),
      ],
    );
  }
}
