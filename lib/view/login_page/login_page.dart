import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/view/login_page/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../controller/email_login_controller.dart';
import '../../controller/google_auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CustomButton customButton = CustomButton();
  final EmailLoginController _emailController =
      Get.find<EmailLoginController>();

  final GoogleAuthController googleAuthController =
      Get.find<GoogleAuthController>();
  final UserController userController = Get.find<UserController>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> googleHandleLogin() async {
    if (userController.userData.value == null) {
      CircularProgressIndicator();
      await googleAuthController.googleLoginController();
      print('Data Value : ${userController.userData.value?.userId}');
    }
    if (userController.userData.value != null) {
      print('Data Value : ${userController.userData.value!.userId}');
      context.go(AppRoutes.homePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ส่วนหัวของหน้าจอ
              const SizedBox(height: 20),
              const Icon(
                Icons.lock_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 8),
              const Text(
                'กรุณาเข้าสู่ระบบเพื่อใช้งานแอปพลิเคชัน',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ฟิลด์กรอกอีเมล
                    TextFormField(
                      controller: _emailTextController,
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ฟิลด์กรอกรหัสผ่าน
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'รหัสผ่าน',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        if (value.length < 6) {
                          return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('ลืมรหัสผ่าน?'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(
                      () => ElevatedButton(
                        onPressed: _emailController.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _emailController.signIn(
                                    _emailTextController.text,
                                    _passwordController.text,
                                    context,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: _emailController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'เข้าสู่ระบบด้วยอีเมล',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              customButton.btnSignUp(
                  iconPath: 'assets/icons/google.png',
                  onPressed: () {
                    googleHandleLogin();
                  },
                  label: 'เข้าสู่ระบบด้วย Google '),

              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'หรือ',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ยังไม่มีบัญชี?'),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.registerpage);
                    },
                    child: const Text('สมัครสมาชิก'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
