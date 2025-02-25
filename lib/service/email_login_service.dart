import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_service.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  static final String userCollection = 'users';

  // Login ด้วย Email/Password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // ตรวจสอบว่ามีข้อมูล User ใน Firestore หรือยัง
      await _userService.createUserIfNotExists(userCredential.user!);

      return true;
    } catch (e) {
      print('Email Login Error: $e');
      return false;
    }
  }

  // สมัครสมาชิกด้วย Email/Password
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // เพิ่มข้อมูลผู้ใช้ลง Firestore
      await _userService.createUserIfNotExists(userCredential.user!);

      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'อีเมลนี้ถูกใช้ลงทะเบียนแล้ว';
      } else if (e.code == 'weak-password') {
        return 'รหัสผ่านของคุณอ่อนเกินไป';
      } else if (e.code == 'invalid-email') {
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      } else {
        return 'เกิดข้อผิดพลาด: ${e.message}';
      }
    } catch (e) {
      return 'เกิดข้อผิดพลาดที่ไม่คาดคิด';
    }
  }

  Future<UsersModel?> saveUserEmailPassword({
    DateTime? birthDay,
  }) async {
    try {
      print('Attempting to create user with email: ');

      var querySnapshot = await _firestore
          .collection(userCollection)
          .where('email', isEqualTo: 'email')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Email is already in use');
        throw Exception("อีเมลนี้ถูกใช้ไปแล้ว");
      }

      print('Creating user with Firebase Authentication...');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: '',
        password: '',
      );

      print(
          'User created with Firebase Auth. UID: ${userCredential.user?.uid}');
      User? user = userCredential.user;
      if (user == null) {
        print('Error: User registration failed, user is null');
        return null;
      }
      await user.sendEmailVerification();

      UsersModel userData = UsersModel(
        userId: user.uid,
        email: 'email',
        password: 'password',
        firstName: '',
        lastName: '',
        birthDay: birthDay!,
        age: 12,
        period: null,
      );

      await _firestore
          .collection(userCollection)
          .doc(user.uid)
          .set(userData.toJson());
      print('User data saved to Firestore successfully');

      return userData;
    } catch (e) {
      print('Error during registration: $e');
      print('Error stack trace: ${StackTrace.current}');
      throw e; // ส่งข้อผิดพลาดต่อเพื่อให้ดักจับในระดับที่สูงขึ้น
    }
  }
}
