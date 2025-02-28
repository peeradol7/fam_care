import 'package:fam_care/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  ProfilePage({
    super.key,
    required this.userId,
  });

  final UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    userController.fetchUserDataById(userId);
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.pop();
          },
          child: Obx(
            () => Text(
              userController.userData.value != null
                  ? '${userController.userData.value!.userId}'
                  : 'Loading...',
            ),
          ),
        ),
      ),
    );
  }
}
