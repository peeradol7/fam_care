import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final UserService _userService = UserService();

  static final String userCollection = 'users';

//ไม่ต้องเซฟ password เข้า firestore แต่passwordจะเซฟให้ทาง Authenแล้ว
  Future<User?> signUpWithEmail(UsersModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);

      String uid = userCredential.user!.uid;

      await _firestore.collection(userCollection).doc(uid).set({
        "userId": uid,
        "email": user.email,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "age": user.age,
        "birthDay": user.birthDay,
        "updatedAt": user.period,
      });
      print("สมัครสมาชิกสำเร็จ!");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "อีเมลนี้มีผู้ใช้งานแล้ว กรุณาใช้อีเมลอื่น";
          break;
        case 'weak-password':
          errorMessage = "รหัสผ่านไม่ปลอดภัย กรุณาใช้รหัสผ่านที่มีความยาวอย่างน้อย 6 ตัวอักษร";
          break;
        case 'invalid-email':
          errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
          break;
        default:
          errorMessage = "เกิดข้อผิดพลาดในการลงทะเบียน: ${e.message}";
      }
      
      print(errorMessage);
      throw errorMessage; // ส่งข้อความกลับไปให้ controller จัดการ
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      throw "เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง";
    }
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
     
     
     // ฟังก์ชันใหม่สำหรับดึงข้อมูลผู้ใช้หลังจาก login
  Future<UsersModel?> getUserData(String uid) async {
    try {
      // ตรวจสอบว่ามีผู้ใช้ที่เข้าสู่ระบบอยู่หรือไม่
      User? currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        throw "ไม่พบข้อมูลผู้ใช้ที่เข้าสู่ระบบ";
      }
      
      // ดึงข้อมูลจาก Firestore โดยใช้ userId ของผู้ใช้ที่เข้าสู่ระบบ
      DocumentSnapshot userDoc = await _firestore
          .collection(userCollection)
          .doc(currentUser.uid)
          .get();
      
      if (!userDoc.exists) {
        throw "ไม่พบข้อมูลผู้ใช้ในฐานข้อมูล";
      }
      
      // แปลงข้อมูลจาก DocumentSnapshot เป็น Map
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      // สร้าง object UsersModel จากข้อมูลที่ดึงมาได้
      UsersModel user = UsersModel(
        userId: userData["userId"],
        email: userData["email"],
        firstName: userData["firstName"],
        lastName: userData["lastName"],
        age: userData["age"],
        birthDay: userData["birthDay"],
        period: userData["updatedAt"],
        // ไม่ต้องเซ็ต password เพราะเป็นข้อมูลที่ละเอียดอ่อน
      );
      
      print("ดึงข้อมูลผู้ใช้สำเร็จ");
      return user;
      
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: $e");
      throw "เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้ กรุณาลองใหม่อีกครั้ง";
    }
  }
}