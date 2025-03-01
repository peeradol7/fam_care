import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/email_login_controller.dart';
import 'package:fam_care/controller/google_auth_controller.dart';
import 'package:fam_care/controller/menu_bar_controller.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(MenuBarController());
  Get.put(GoogleAuthController());
  Get.put(UserController());
  Get.put(EmailLoginController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
    );
  }
}
