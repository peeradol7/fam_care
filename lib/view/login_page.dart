import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controller/email_login_controller.dart';
import '../controller/google_auth_controller.dart'; // เพิ่ม controller สำหรับ Google Login

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EmailLoginController _emailController = Get.put(EmailLoginController());
  final GoogleAuthController _googleController = Get.put(GoogleAuthController()); // เรียกใช้ controller ที่มีอยู่แล้ว
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        centerTitle: true,
      ),
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
              const Text(
                'ยินดีต้อนรับกลับมา',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              
              // ส่วนฟอร์มเข้าสู่ระบบด้วย Email/Password
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
                    
                    // ลิงก์ลืมรหัสผ่าน
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: นำทางไปยังหน้าลืมรหัสผ่าน
                          Get.snackbar(
                            'แจ้งเตือน',
                            'ฟีเจอร์นี้ยังไม่เปิดให้ใช้งาน',
                            backgroundColor: Colors.orange.withOpacity(0.7),
                            colorText: Colors.white,
                          );
                        },
                        child: const Text('ลืมรหัสผ่าน?'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // ปุ่มเข้าสู่ระบบด้วย Email/Password
                    Obx(() => ElevatedButton(
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'เข้าสู่ระบบด้วยอีเมล',
                              style: TextStyle(fontSize: 16),
                            ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // ตัวแบ่งระหว่างการเข้าสู่ระบบด้วย Email และ Google
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
              
              // // ปุ่มเข้าสู่ระบบด้วย Google
              // Obx(() => ElevatedButton.icon(
              //   onPressed: _googleController.isLoading.value
              //       ? null
              //       : () => _googleController.googleLogin(context),
              //   icon: _googleController.isLoading.value
              //       ? const SizedBox(
              //           width: 24,
              //           height: 24,
              //           child: CircularProgressIndicator(
              //             strokeWidth: 2,
              //             color: Colors.red,
              //           ),
              //         )
              //       : Image.asset(
              //           'assets/images/google_logo.png',
              //           height: 24,
              //           width: 24,
              //         ),
              //   label: const Text(
              //     'เข้าสู่ระบบด้วย Google',
              //     style: TextStyle(fontSize: 16),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: const Size.fromHeight(50),
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.black87,
              //     side: const BorderSide(color: Colors.grey),
              //   ),
              // )),
              const SizedBox(height: 24),
              
              // ลิงก์ไปยังหน้าสมัครสมาชิก
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ยังไม่มีบัญชี?'),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
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