import 'package:fam_care/controller/email_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EmailLoginController _controller = Get.find<EmailLoginController>();

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลผู้ใช้เมื่อเปิดหน้าจอ
    _controller.getCurrentUser();
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
            onPressed: () => _controller.signOut(context),
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

        // แสดงข้อมูลผู้ใช้ที่ login แล้ว
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
              
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // อีเมลผู้ใช้
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('อีเมล'),
                        subtitle: Text(user.email.toString()),
                      ),
                      
                      const Divider(),
                      
                      // ชื่อผู้ใช้
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('ชื่อ-นามสกุล'),
                        subtitle: Text('${user.firstName} ${user.lastName}'),
                      ),
                      
                      const Divider(),
                      
                      // อายุ
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('อายุ'),
                        subtitle: Text('${user.age} ปี'),
                      ),
                      
                      const Divider(),
                      
                      ListTile(
                        leading: const Icon(Icons.cake),
                        title: const Text('วันเกิด'),
                        subtitle: Text(user.birthDay != null 
                            ? DateFormat('dd/MM/yyyy').format(user.birthDay!)  // แสดงวันที่ในรูปแบบ `dd/MM/yyyy`
                            : 'ไม่ระบุ'),  // ถ้าเป็น null ให้แสดงข้อความ
                      )
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // ส่วนอื่น ๆ ของแอปพลิเคชัน
              const Text(
                'ยินดีต้อนรับสู่แอปพลิเคชัน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'คุณสามารถใช้งานฟีเจอร์ต่าง ๆ ของแอปพลิเคชันได้แล้ว',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }),
    );
  }
}