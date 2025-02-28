import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final UserService _userService = UserService();

  static final String userCollection = 'users';

  Future<User?> signUpWithEmail(UsersModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);

      String uid = userCredential.user!.uid;

      DateTime nextPeriodDate = user.period!.add(Duration(days: 28));

      await _firestore.collection(userCollection).doc(uid).set(
        {
          "userId": uid,
          "email": user.email,
          "firstName": user.firstName,
          "lastName": user.lastName,
          "age": _calculateAge(user.birthDay!),
          "birthDay": user.birthDay!.toIso8601String(),
          "period": user.period!.toIso8601String(),
          "nextPeriodDate": nextPeriodDate.toIso8601String(),
        },
      );

      print("สมัครสมาชิกสำเร็จ!");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "อีเมลนี้มีผู้ใช้งานแล้ว กรุณาใช้อีเมลอื่น";
          break;
        case 'weak-password':
          errorMessage =
              "รหัสผ่านไม่ปลอดภัย กรุณาใช้รหัสผ่านที่มีความยาวอย่างน้อย 6 ตัวอักษร";
          break;
        case 'invalid-email':
          errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
          break;
        default:
          errorMessage = "เกิดข้อผิดพลาดในการลงทะเบียน: ${e.message}";
      }

      print(errorMessage);
      throw errorMessage;
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      throw "เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง";
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      print("เข้าสู่ระบบสำเร็จ!");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "ไม่พบผู้ใช้งานนี้ในระบบ";
          break;
        case 'wrong-password':
          errorMessage = "รหัสผ่านไม่ถูกต้อง";
          break;
        case 'user-disabled':
          errorMessage = "บัญชีผู้ใช้นี้ถูกระงับการใช้งาน";
          break;
        case 'too-many-requests':
          errorMessage = "มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่ภายหลัง";
          break;
        case 'invalid-email':
          errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
          break;
        default:
          errorMessage = "เกิดข้อผิดพลาดในการเข้าสู่ระบบ: ${e.message}";
      }

      print(errorMessage);
      throw errorMessage;
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      throw "เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง";
    }
  }

  Future<UsersModel?> getUserData(String uid) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw "ไม่พบข้อมูลผู้ใช้ที่เข้าสู่ระบบ";
      }

      DocumentSnapshot userDoc = await _firestore
          .collection(userCollection)
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw "ไม่พบข้อมูลผู้ใช้ในฐานข้อมูล";
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // ฟังก์ชันช่วยแปลง Timestamp เป็น DateTime
      DateTime? parseTimestamp(dynamic value) {
        if (value is Timestamp) {
          return value.toDate();
        }
        return null;
      }

      // ดึงข้อมูลและแปลงค่า birthDay และ updatedAt
      UsersModel user = UsersModel(
        userId: userData["userId"] ?? "",
        email: userData["email"] ?? "",
        firstName: userData["firstName"] ?? "",
        lastName: userData["lastName"] ?? "",
        birthDay: parseTimestamp(
            userData["birthDay"]), // ✅ แปลง Timestamp เป็น DateTime
        period: parseTimestamp(
            userData["updatedAt"]), // ✅ แปลง Timestamp เป็น DateTime
      );

      print("ดึงข้อมูลผู้ใช้สำเร็จ: ${user.birthDay}");
      return user;
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: $e");
      throw "เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้ กรุณาลองใหม่อีกครั้ง";
    }
  }
}
