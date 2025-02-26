import 'package:fam_care/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // รายการรูปภาพสำหรับ carousel
    final List<String> imageList = [
      'assets/images/family1.jpg',
      'assets/images/family2.jpg',
      'assets/images/family3.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FamCare'),
        backgroundColor: Colors.blue.shade100,
        actions: [
          // ปุ่ม Login ที่มุมขวาบนของ AppBar
          TextButton.icon(
            icon: const Icon(Icons.login, color: Colors.blue),
            label: const Text(
              'Login',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              // นำทางไปยังหน้า Login ด้วย GoRouter
              context.push(AppRoutes.loginpage);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. ส่วน Hero - Carousel สำหรับรูปภาพหลัก
            CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: imageList.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 2. ส่วนข้อความต้อนรับ
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Welcome to FamCare',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your complete family care solution. Connect with your loved ones and manage family activities in one place.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // 3. ส่วนโฆษณา (Banner)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 40),
                    SizedBox(width: 16),
                    Text(
                      'Special Offer: Premium Free for 30 Days!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. ปุ่ม Login หลัก
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text(
                  'Login to Your Account',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // นำทางไปยังหน้า Login ด้วย GoRouter
                  context.push(AppRoutes.loginpage);
                },
              ),
            ),

            const SizedBox(height: 16),

            // 5. ปุ่ม Register
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text(
                  'Create New Account',
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // นำทางไปยังหน้า Register ด้วย GoRouter
                  context.push(AppRoutes.registerpage);
                },
              ),
            ),

            const SizedBox(height: 30),

            // 6. ส่วนโฆษณา (Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        'Family Calendar',
                        Icons.calendar_today,
                        Colors.green.shade100,
                      ),
                      _buildFeatureCard(
                        'Shared Photos',
                        Icons.photo_library,
                        Colors.purple.shade100,
                      ),
                      _buildFeatureCard(
                        'Location Sharing',
                        Icons.location_on,
                        Colors.orange.shade100,
                      ),
                      _buildFeatureCard(
                        'Family Chat',
                        Icons.chat,
                        Colors.blue.shade100,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method สำหรับสร้าง card แสดงคุณสมบัติต่างๆ
  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}