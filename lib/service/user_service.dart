import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/users_model.dart';

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

  Future<UsersModel?> fetchUserDataByUserId(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(usersCollections)
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        return null;
      }

      final data = userDoc.data()!;

      return UsersModel(
        userId: data['uid'] ?? uid,
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        birthDay: data['birthDay'] is Timestamp
            ? (data['birthDay'] as Timestamp).toDate()
            : (data['birthDay'] is String
                ? DateTime.tryParse(data['birthDay'])
                : null),
        period: data['period'] is Timestamp
            ? (data['period'] as Timestamp).toDate()
            : (data['period'] is String
                ? DateTime.tryParse(data['period'])
                : null),
      );
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
