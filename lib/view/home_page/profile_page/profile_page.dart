import 'package:fam_care/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditPage extends StatelessWidget {
  final String userId;

  ProfileEditPage({
    super.key,
    required this.userId,
  });

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userController.fetchUserDataById(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลผู้ใช้'),
        actions: [
          Obx(
            () => userController.isSaving.value
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () async {
                      if (await userController.saveUserData(userId, '')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('เกิดข้อผิดพลาด โปรดลองอีกครั้ง')),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.userData.value == null) {
          return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: userController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ข้อมูลที่ไม่สามารถแก้ไขได้
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ข้อมูลที่ไม่สามารถแก้ไขได้',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'User ID: ${userController.userData.value!.userId ?? ""}'),
                        const SizedBox(height: 8),
                        Text(
                            'Email: ${userController.userData.value!.email ?? ""}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'ข้อมูลที่สามารถแก้ไขได้',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // FirstName
                TextFormField(
                  controller: userController.firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดกรอกชื่อ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // LastName
                TextFormField(
                  controller: userController.lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'นามสกุล',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดกรอกนามสกุล';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Birthday
                Obx(() => TextFormField(
                      controller: userController.birthDateController,
                      decoration: const InputDecoration(
                        labelText: 'วันเกิด',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              userController.birthDate.value ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          userController.updateBirthDate(pickedDate);
                        }
                      },
                    )),

                const SizedBox(height: 16),

                // Period Date
                Obx(() => TextFormField(
                      controller: userController.periodDateController,
                      decoration: const InputDecoration(
                        labelText: 'วันที่มีประจำเดือน',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              userController.periodDate.value ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          userController.updatePeriodDate(pickedDate);
                        }
                      },
                    )),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                        onPressed: userController.isSaving.value
                            ? null
                            : () async {
                                if (await userController.saveUserData(
                                    userId, '')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('บันทึกข้อมูลสำเร็จ')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'เกิดข้อผิดพลาด โปรดลองอีกครั้ง')),
                                  );
                                }
                              },
                        //asdsssss
                        child: userController.isSaving.value
                            ? const CircularProgressIndicator()
                            : const Text('บันทึกข้อมูล'),
                      )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
