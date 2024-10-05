import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthUtils {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await auth.isDeviceSupported();
    } catch (e) {
      print("Error checking biometrics support: $e");
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: Platform.isIOS
            ? "Scan your Face ID to authenticate"
            : "Scan your fingerprint to authenticates",
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}
