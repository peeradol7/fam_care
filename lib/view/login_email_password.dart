import 'package:fam_care/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fam_care/controller/email_login_controller.dart';
import 'package:go_router/go_router.dart';



class LoginEmailPassword extends StatefulWidget {
  const LoginEmailPassword({super.key});

  @override
  State<LoginEmailPassword> createState() => _LoginEmailPasswordState();
}

class _LoginEmailPasswordState extends State<LoginEmailPassword> {
  // เข้าถึง controller ที่เตรียมไว้แล้ว
  final EmailLoginController _controller = Get.put(EmailLoginController());
  
  // Controller สำหรับ form field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Key สำหรับ form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // ตัวแปรสำหรับควบคุมการแสดงรหัสผ่าน
  bool _obscurePassword = true;
  
  @override
  void dispose() {
    // คืนทรัพยากรเมื่อ widget ถูกทำลาย
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ฟังก์ชันจัดการการเข้าสู่ระบบ
  void _handleLogin() async {
    // ตรวจสอบความถูกต้องของฟอร์ม
    if (_formKey.currentState!.validate()) {
      try {
        // เรียกใช้ controller เพื่อเข้าสู่ระบบ
        await _controller.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        // เช็คว่าการเข้าสู่ระบบสำเร็จหรือไม่โดยตรวจสอบ user ปัจจุบัน
        if (FirebaseAuth.instance.currentUser != null) {
          // ถ้าสำเร็จให้ไปยังหน้าหลักหลังจากเข้าสู่ระบบ
          //context.go(AppRoutes);
        }
      } catch (e) {
        // กรณีเกิดข้อผิดพลาดที่ไม่ได้จัดการโดย controller
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบด้วยอีเมล'),
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ไอคอนแอปพลิเคชัน
                        const Icon(
                          Icons.family_restroom,
                          size: 64,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'เข้าสู่ระบบ FamCare',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // ฟิลด์กรอกอีเมล
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            hintText: 'กรอกอีเมลของคุณ',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
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
                        const SizedBox(height: 20),
                        
                        // ฟิลด์กรอกรหัสผ่าน
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            hintText: 'กรอกรหัสผ่าน',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
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
                        
                        // // ลิงก์ลืมรหัสผ่าน
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       context.go(AppRoutes.forgotPasswordPage);
                        //     },
                        //     child: const Text(
                        //       'ลืมรหัสผ่าน?',
                        //       style: TextStyle(color: Colors.blue),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 24),
                        
                        // ปุ่มเข้าสู่ระบบ
                        Obx(() => _controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _handleLogin,
                              child: const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                        ),
                        const SizedBox(height: 24),
                        
                        // ลิงก์ไปยังหน้าลงทะเบียน
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('ยังไม่มีบัญชี?'),
                            TextButton(
                              onPressed: () {
                                context.go(AppRoutes.registerpage);
                              },
                              child: const Text(
                                'สมัครสมาชิก',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // ปุ่มกลับไปหน้าหลัก
                        TextButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('กลับไปหน้าหลัก'),
                          onPressed: () {
                            context.go(AppRoutes.landingPage);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}