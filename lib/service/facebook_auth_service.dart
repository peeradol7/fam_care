import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        print("Login result status: ${result.status}");
        print("Login result message: ${result.message}");
        return await _auth.signInWithCredential(credential);
      } else {
        print("Facebook Login Failed: ${result.status}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      print("Detailed error during Facebook sign in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await FacebookAuth.instance.logOut();
  }
}
