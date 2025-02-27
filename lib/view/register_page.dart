import 'package:fam_care/controller/email_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  @override
  void initState() {
    super.initState();

    // Listener เมื่อผู้ใช้กรอกอายุ
    ageController.addListener(() {
      int? age = int.tryParse(ageController.text.trim());
      if (age != null && age > 0) {
        setState(() {
          selectedDate.value = DateTime.now().subtract(Duration(days: age * 365));
          birthDayController.text = DateFormat('dd/MM/yyyy').format(selectedDate.value!);
        });
      }
    });

    // Listener เมื่อผู้ใช้กรอกวันเกิด
    birthDayController.addListener(() {
      try {
        DateTime birthDate = DateFormat('dd/MM/yyyy').parse(birthDayController.text.trim());
        setState(() {
          selectedDate.value = birthDate;
          int calculatedAge = DateTime.now().year - birthDate.year;
          ageController.text = calculatedAge.toString();
        });
      } catch (e) {
        // ถ้ากรอกไม่ถูก format จะไม่ทำอะไร
      }
    });
  }

  void _register() {
    UsersModel user = UsersModel(
      email: emailController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      password: passwordController.text.trim(),
      age: int.tryParse(ageController.text.trim()) ?? 0,
      birthDay: selectedDate.value,
      period: null,
    );

    authController.signUp(user);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate.value = picked;
        birthDayController.text = DateFormat('dd/MM/yyyy').format(picked);
        ageController.text = (DateTime.now().year - picked.year).toString();
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    birthDayController.dispose();
    passwordController.dispose();
    super.dispose();
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
              readOnly: true,
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
