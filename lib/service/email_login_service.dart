import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Login ด้วย Email/Password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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
}

