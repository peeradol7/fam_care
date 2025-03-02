import 'package:fam_care/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditPage extends StatefulWidget {
  final String userId;

  ProfileEditPage({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUserDataById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลผู้ใช้'),
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userData.value == null) {
            return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller.firstNameController,
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
                    controller: controller.lastNameController,
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

                  // Birthday - ไม่ใช้ Obx ที่นี่
                  TextFormField(
                    controller: controller.birthDateController,
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
                            controller.birthDate.value ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        controller.updateBirthDate(pickedDate);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: controller.periodDateController,
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
                            controller.periodDate.value ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        controller.updatePeriodDate(pickedDate);
                      }
                    },
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () async {
                              if (await controller.saveUserData(
                                  widget.userId, '')) {
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
                      child: controller.isSaving.value
                          ? const CircularProgressIndicator()
                          : const Text('บันทึกข้อมูล'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
