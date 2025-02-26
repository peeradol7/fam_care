import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailLoginController extends GetxController {
  final EmailAuthService authService = EmailAuthService();
  var isLoading = false.obs;
  var userData = Rxn(UsersModel);

  Future<void> signUp(UsersModel userModel) async {
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

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      User? userCredential = await authService.signIn(email, password);
      if (userCredential != null) {
      } else {
        Get.snackbar("ผิดพลาด", "อีเมลหรือรหัสผ่านไม่ถูกต้อง");
      }
    } catch (e) {
      Get.snackbar("ผิดพลาด", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
