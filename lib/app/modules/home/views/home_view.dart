import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      String message = Get.arguments["message"] ?? "";
      String type = Get.arguments["type"] ?? "info";

      if (type == "success") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Success",
            message,
          );
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(
          20,
        ),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Add Product";
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.addProduct);
              break;
            case 1:
              title = "Products";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.product);
              break;
            case 2:
              title = "QR CODE";
              icon = Icons.qr_code;
              onTap = () {};
              break;
            case 3:
              title = "Catalog";
              icon = Icons.document_scanner_outlined;
              onTap = () {
                controller.downloadCatalog();
              };
              break;
          }
          return Material(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
            child: InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      icon,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            title: "Logout Confirmation",
            middleText: "Are you sure you want to log out?",
            textConfirm: "Yes",
            textCancel: "No",
            confirmTextColor: Colors.white,
            onConfirm: () async {
              Map<String, dynamic> result = await authC.logout();

              if (result["error"] == false) {
                // Pass the message when navigating to the login page
                Get.offAllNamed(Routes.login, arguments: {
                  "message": "Logout Successful",
                  "type": "success",
                });
              } else {
                Get.snackbar(
                  "Error",
                  result["message"] ?? "Logout failed, please try again.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
              Get.back();
            },
            onCancel: () {
              Get.back();
            },
          );
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
