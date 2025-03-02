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
      print(
          "กำลังค้นหาข้อมูลจาก collection: $usersCollections, document ID: $uid");

      final userDoc = await FirebaseFirestore.instance
          .collection(usersCollections)
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        print("ไม่พบเอกสารสำหรับ UID: $uid ใน collection: $usersCollections");
        return null;
      }

      final data = userDoc.data()!;
      print("ข้อมูลดิบจาก Firestore: $data");

      try {
        final userModel = UsersModel.fromJson(data);
        print("แปลงข้อมูลสำเร็จ: $userModel");
        return userModel;
      } catch (e) {
        print("เกิดข้อผิดพลาดในการแปลง JSON เป็น UsersModel: $e");
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(usersCollections).doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }
}
