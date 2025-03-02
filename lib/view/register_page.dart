import 'package:fam_care/controller/email_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../model/users_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final EmailLoginController authController = Get.put(EmailLoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController periodDateController = TextEditingController();

  DateTime? _birthDate;
  DateTime? _periodDate;

  @override
  void initState() {
    super.initState();
    birthDateController.text = "";
    periodDateController.text = "";
  }

  void _register() {
    if (_birthDate == null || _periodDate == null) {
      Get.snackbar("ผิดพลาด", "กรุณาเลือกวันเกิดและวันเป็นประจำเดือน");
      return;
    }

    UsersModel user = UsersModel(
      email: emailController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      password: passwordController.text.trim(),
      birthDay: _birthDate,
      period: _periodDate,
      authMethod: 'email',
    );

    authController.emailSignUpController(user,context);
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    periodDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'ชื่อจริง'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'นามสกุล'),
            ),
            TextFormField(
              controller: birthDateController,
              decoration: InputDecoration(labelText: 'Birth Date'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(
                    () {
                      _birthDate = pickedDate;
                      birthDateController.text =
                          "${_birthDate!.toLocal()}".split(' ')[0];
                    },
                  );
                }
              },
            ),
            TextFormField(
              controller: periodDateController,
              decoration: InputDecoration(labelText: 'Period Date'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _periodDate = pickedDate;
                    periodDateController.text =
                        "${_periodDate!.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() => authController.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                  )),
          ],
        ),
      ),
    );
  }
}
