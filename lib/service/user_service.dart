import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String usersCollections = 'users';

  Future<bool> checkUserExists(String uid) async {
    var userDoc = await _firestore.collection(usersCollections).doc(uid).get();
    return userDoc.exists;
  }

  Future<void> saveUserProfile({
    required String firstName,
    required String lastName,
    required DateTime birthDay,
  }) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection("users").doc(uid).set({
      'userId': uid,
      'email': _auth.currentUser!.email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDay': Timestamp.fromDate(birthDay),
      'age': DateTime.now().year - birthDay.year,
    });
  }
}
