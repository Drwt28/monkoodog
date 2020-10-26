import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {


  FirebaseAuth _auth  = FirebaseAuth.instance;

  // Determine if Apple SignIn is available
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<FirebaseUser> appleSignIn() async {
    try {

      final AuthorizationResult appleResult = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple here
      }

      final AuthCredential credential = OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken: String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      // Optional, Update user data in Firestore


      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }
}