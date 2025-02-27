import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/menu_bar_controller.dart';
import 'widget/menu_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuBarController controller = Get.find<MenuBarController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(
                () => PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.selectedIndex.value = index;
                  },
                  physics: controller.selectedIndex.value == 1
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
                  children: [
                    CustomScrollView(
                      slivers: [],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MenuBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
