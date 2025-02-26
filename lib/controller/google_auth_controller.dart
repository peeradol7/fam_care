import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/google_auth_service.dart';
import 'package:get/get.dart';

import '../service/user_service.dart';

class GoogleAuthController extends GetxController {
  final GoogleAuthService authService = GoogleAuthService();
  final UserService _userService = UserService();

  RxBool isLoading = false.obs;
  RxBool isUserExist = false.obs;
  var userData = Rxn<UsersModel>();

  Future<void> googleLoginController() async {
    try {
      isLoading(true);
      await googleLogin();
    } finally {
      isLoading(false);
    }
  }

  Future<void> googleLogin() async {
    final result = await authService.loginWithGoogle();
    if (result != null) {
      final data = await authService.fetchUserDataByUserId(result.uid);
      userData.value = data;
    } else {
      print('Google login failed: user is null');
    }
  }

  void logout() async {
    authService.signOut();
  }
}
