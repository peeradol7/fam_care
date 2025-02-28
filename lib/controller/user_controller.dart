import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  var userData = Rxn<UsersModel>();
  Rx<UsersModel?> editUserData = Rx<UsersModel?>(null);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final periodDateController = TextEditingController();
  final birthDate = Rx<DateTime?>(null);
  final periodDate = Rx<DateTime?>(null);
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  Future<void> loadUserFromPrefs() async {
    isLoading.value = true;
    final user = await SharedPrefercenseService.getUser();
    if (user != null) {
      userData.value = user;
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    ever(birthDate, (_) {
      if (birthDate.value != null) {
        birthDateController.text =
            "${birthDate.value?.toLocal()}".split(' ')[0];
      }
    });

    ever(periodDate, (_) {
      if (periodDate.value != null) {
        periodDateController.text =
            "${periodDate.value?.toLocal()}".split(' ')[0];
      }
    });
  }

  Future<void> fetchUserDataById(String userId) async {
    isLoading.value = true;
    userData.value = await _userService.fetchUserDataByUserId(userId);

    if (userData.value != null) {
      // กำหนดค่าเริ่มต้นให้กับ controllers
      firstNameController.text = userData.value!.firstName ?? '';
      lastNameController.text = userData.value!.lastName ?? '';
      birthDate.value = userData.value?.birthDay;
      periodDate.value = userData.value?.period;
    }

    isLoading.value = false;
  }

  Future<bool> saveUserData(String userId, String authMethod) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isSaving.value = true;
    try {
      // สร้าง Map เพื่อส่งเฉพาะข้อมูลที่ต้องการอัพเดต
      final Map<String, dynamic> updateData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'birthDay': birthDate.value?.toIso8601String(),
        'period': periodDate.value?.toIso8601String(),
      };

      final success = await _userService.updateUser(userId, updateData);

      if (success) {
        final updatedUser = UsersModel(
          userId: userId,
          email: userData.value?.email,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          birthDay: birthDate.value,
          period: periodDate.value,
          authMethod: authMethod,
        );

        userData.value = updatedUser;
      }

      return success;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void updateBirthDate(DateTime date) {
    birthDate.value = date;

    // อัปเดตค่าใน TextEditingController สำหรับแสดงผลในฟอร์ม
    birthDateController.text = "${date.toLocal()}".split(' ')[0];

    // สามารถเพิ่มการทำงานเพิ่มเติมได้ตามต้องการ เช่น คำนวณอายุอัตโนมัติ
    // calculateAge(date);
  }

// ฟังก์ชันอัปเดตวันมีประจำเดือน
  void updatePeriodDate(DateTime date) {
    periodDate.value = date;

    // อัปเดตค่าใน TextEditingController สำหรับแสดงผลในฟอร์ม
    periodDateController.text = "${date.toLocal()}".split(' ')[0];

    // สามารถเพิ่มการทำงานเพิ่มเติมได้ตามต้องการ เช่น คำนวณวันที่ควรเตือน
    // calculateNextPeriodReminder(date);
  }

  Future<void> signOut(BuildContext context) async {
    try {
      SharedPrefercenseService.removeUser();
      await FirebaseAuth.instance.signOut();
      userData.value = null;
    } catch (e) {}
  }

  int calculateAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  DateTime calculateNextPeriod(DateTime lastPeriod, {int cycleDays = 28}) {
    return lastPeriod.add(Duration(days: cycleDays));
  }

  @override
  void onClose() {
    // ต้องทำลาย controller เมื่อเลิกใช้งาน
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    periodDateController.dispose();
    super.onClose();
  }
}
