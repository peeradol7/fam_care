import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fam_care/view/login_page.dart'; // ตรวจสอบว่าได้ import หน้า LoginPage หรือยัง

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // เมื่อกดปุ่ม ให้เปลี่ยนเส้นทางไปที่หน้า LoginPage
                context.go('/loginpage');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
