import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fam_care/model/users_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ตรวจสอบว่าผู้ใช้มีข้อมูลใน Firestore หรือยัง ถ้ายังให้สร้างใหม่
  Future<void> createUserIfNotExists(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // กำหนดค่าเริ่มต้นของ UserModel
      UsersModel newUser = UsersModel(
        userId: user.uid,
        email: user.email ?? '',
        password: null,
        firstName: '',
        lastName: '',
        birthDay: DateTime.now(),
        age: 0,
        period: null,
      );

      // บันทึกลง Firestore
      await userDoc.set(newUser.toJson());
    }
  }

  // ดึงข้อมูล User จาก Firestore
  Future<UsersModel?> getUser(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      return UsersModel.fromSnapshot(docSnapshot);
    }
    return null;
  }

  // อัปเดตข้อมูล User
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }
}
