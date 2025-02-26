// 1. ปรับปรุง Login Page
import 'package:fam_care/app_routes.dart';
import 'package:fam_care/service/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final GoogleAuthService _authService = GoogleAuthService();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.family_restroom,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to FamCare',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // ปุ่ม Login ด้วย Google
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Login with Google'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        var userCredential = await _authService.signInWithGoogle();
                        if (userCredential != null) {
                          print('Login Success: ${userCredential.user!.email}');
                          // เมื่อเข้าสู่ระบบสำเร็จให้นำทางไปที่หน้าหลัก
                          context.go(AppRoutes.landingPage);
                        } else {
                          // แสดงข้อความ error
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login Failed. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // ปุ่ม Login ด้วย Email/Password
                    ElevatedButton.icon(
                      icon: const Icon(Icons.email),
                      label: const Text('Login with Email'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.push(AppRoutes.login_email_password_page);
                      },
                    ),

                    const SizedBox(height: 30),

                    // ปุ่ม Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          child: const Text(
                            'Create New Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            context.push(AppRoutes.registerpage);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}