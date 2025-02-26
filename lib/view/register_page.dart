import 'package:fam_care/controller/email_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/users_model.dart';

class RegisterPage extends StatelessWidget {
  final EmailLoginController authController = Get.put(EmailLoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  void _register() {
    UsersModel user = UsersModel(
      email: emailController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      password: passwordController.text.trim(),
      age: int.tryParse(ageController.text.trim()) ?? 0,
      birthDay: selectedDate.value!,
      period: null,
    );

    authController.signUp(user);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
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
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email')),
            TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name')),
            TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name')),
            TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number),
            TextField(
              controller: birthDayController,
              decoration: InputDecoration(
                labelText: 'Birth Day',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true, // ไม่ให้พิมพ์เอง
            ),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
            SizedBox(height: 20),
            Obx(() => authController.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register, child: Text('Register'))),
          ],
        ),
      ),
    );
  }
}
