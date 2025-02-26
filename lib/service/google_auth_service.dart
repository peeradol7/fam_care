import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      final isAvailable = await _googleSignIn.isSignedIn();
      print('Test Google Sign In available: $isAvailable');

      await _googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Sign in aborted by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection(userCollection)
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
          });
        }
        return user;
      } else {
        print("Google Sign-In failed.");
        return null;
      }
    } catch (e, stackTrace) {
      print('Detailed error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<UsersModel?> fetchUserDataByUserId(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(userCollection).doc(userId).get();

      if (doc.exists) {
        return UsersModel.fromSnapshot(doc);
      } else {
        print("User not found!");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
}
