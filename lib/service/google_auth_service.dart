import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Sign in aborted by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        try {
          UsersModel userModel = UsersModel(
            userId: user.uid,
            email: user.email ?? '',
            firstName: '',
            lastName: '',
            password: '',
            birthDay: DateTime.now(),
            period: DateTime.now(),
          );
          _firestore
              .collection(userCollection)
              .doc(user.uid)
              .set(userModel.toJson());

          SharedPrefercenseService.saveUser(userModel);

          return user;
        } catch (firestoreError) {
          return user;
        }
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      print('Detailed error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<UsersModel?> fetchUserDataByUserId(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        print('User document does not exist or is empty');
        return null;
      }

      print('User document data: ${userDoc.data()}');

      final data = userDoc.data()!;

      return UsersModel(
        userId: data['uid'] ?? uid,
        email: data['email'] ?? '',
      );
    } catch (e) {
      print('Error fetching user data: $e');
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
