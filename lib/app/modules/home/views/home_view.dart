import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode_app/app/controllers/auth_controller.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await authC.logout();
          if (hasil["error"] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar("Error", hasil["error"]);
          }
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
