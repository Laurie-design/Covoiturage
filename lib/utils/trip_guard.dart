import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../views/signin_view.dart';
import '../views/identity_verification_view.dart';
import '../views/publish_trip_view.dart';

class TripGuard {
  static void checkAuthAndNavigate(BuildContext context) {
    final auth = AuthService();

    if (!auth.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInView()),
      );
      return;
    }

    if (!auth.isFullyVerified) {
      auth.setRole(true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IdentityVerificationView(
            isDriver: true,
          ),
        ),
      );
      return;
    }

    auth.setRole(true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PublishTripView()),
    );
  }
}
