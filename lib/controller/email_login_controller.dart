import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmailLoginController extends GetxController {
  final EmailAuthService authService = EmailAuthService();
  final UserController userController = Get.put(UserController());
  var isLoading = false.obs;
  var userData = Rxn<UsersModel?>(null);


  Future<void> emailSignUpController(UsersModel userModel) async {
    isLoading.value = true;
    try {
      User? userCredential = await authService.signUpWithEmail(userModel);
      if (userCredential != null) {
        Get.snackbar("สมัครสำเร็จ!", "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ");
      }
    } catch (e) {
      Get.snackbar("ผิดพลาด", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> signIn(
      String email, String password, BuildContext context) async {
    isLoading.value = true;
    try {
      User? userCredential = await authService.signIn(email, password);

      if (userCredential != null) {
        print("ล็อกอินสำเร็จด้วย UID: ${userCredential.uid}");
        
        // ดึงข้อมูลจาก Firestore ตาม UID
        await userController.fetchUserDataById(userCredential.uid);

        // ตรวจสอบว่าข้อมูลถูกดึงมาแล้วหรือไม่
        if (userController.userData.value != null) {
          print("ดึงข้อมูลผู้ใช้สำเร็จ: ${userController.userData.value!.firstName} ${userController.userData.value!.lastName}");
        } else {
          print("ดึงข้อมูลผู้ใช้ไม่สำเร็จ");
        }

        if (context.mounted) {
          context.go(AppRoutes.homePage);
        }
      } else {
        print("ล็อกอินไม่สำเร็จ: ไม่ได้รับข้อมูล User");
      }
    } catch (e) {
      print('Error during sign in: $e');
      Get.snackbar("เกิดข้อผิดพลาด", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}
