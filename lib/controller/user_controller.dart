import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  var userData = Rxn<UsersModel>();

  RxBool isLoading = false.obs;

  Future<void> loadUserFromPrefs() async {
    isLoading.value = true;
    final user = await SharedPrefercenseService.getUser();
    if (user != null) {
      userData.value = user;
    }
    isLoading.value = false;
  }

  Future<void> fetchUserDataById(String userId) async {
    try {
      isLoading.value = true;
      final data = await _userService.fetchUserDataByUserId(userId);
      userData.value = data;
      isLoading.value = false;
    } catch (e) {
      print(e);
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
