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
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in signIn: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
