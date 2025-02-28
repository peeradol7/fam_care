import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/view/home_page/widget/logout_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController _controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _controller.loadUserFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => LogoutDialogWidget(),
              );
            },
            tooltip: 'ออกจากระบบ',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.userData.value == null) {
          return const Center(
            child: Text(
              'ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบอีกครั้ง',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final user = _controller.userData.value!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ข้อมูลผู้ใช้',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('อีเมล',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(user.email!),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ชื่อ-นามสกุล',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${user.firstName} ${user.lastName}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.cake),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('วันเกิด',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(user.birthDay != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(user.birthDay!)
                                    : 'ไม่ระบุ'),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                final route = AppRoutes.profilePage;
                                final userId = user.userId;
                                context.push('$route/$userId');
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
