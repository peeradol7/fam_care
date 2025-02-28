import 'package:fam_care/app_routes.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/email_auth_service.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmailLoginController extends GetxController {
  final EmailAuthService authService = EmailAuthService();

  var isLoading = false.obs;
  var userData = Rxn<UsersModel?>(null);

  Future<void> emailSignUpController(UsersModel userModel) async {
    isLoading.value = true;
    try {
      User? userCredential = await authService.signUpWithEmail(userModel);
      if (userCredential != null) {
        Get.snackbar("สำเร็จ", "สมัครสมาชิกเรียบร้อย!");
      } else {
        Get.snackbar("ผิดพลาด", "สมัครสมาชิกไม่สำเร็จ");
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
        UsersModel? user = await authService.getUserData(userCredential.uid);
        userData.value = user;

        if (context.mounted) {
          context.go(AppRoutes.homePage);
        }
      }
    } catch (e) {
      print('Error $e');
    } finally {
      isLoading.value = false;
    }
  }

  // เพิ่มฟังก์ชันสำหรับดึงข้อมูลผู้ใช้ที่เข้าสู่ระบบอยู่
  Future<void> getCurrentUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        UsersModel? user = await authService.getUserData(currentUser.uid);
        userData.value = user;
      }
    } catch (e) {
      Get.snackbar("ผิดพลาด", "ไม่สามารถดึงข้อมูลผู้ใช้ได้: ${e.toString()}",
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      SharedPrefercenseService.removeUser();
      await FirebaseAuth.instance.signOut();
      userData.value = null;
    } catch (e) {}
  }
}
