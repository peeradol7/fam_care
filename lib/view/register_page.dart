import 'package:flutter/material.dart';
import '../service/email_login_service.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final EmailAuthService _authService = EmailAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String? result = await _authService.registerWithEmail(email, password);
    
    if (result == 'success') {
      print('Register Success');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สมัครสมาชิกสำเร็จ!')),
      );
    } else {
      print('Register Failed: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result!)), // แสดงข้อความผิดพลาด
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Register'),
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}
