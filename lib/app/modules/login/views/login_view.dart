import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode_app/app/controllers/auth_controller.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passC = TextEditingController(text: "admin123");

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
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => TextField(
              autocorrect: false,
              controller: passC,
              keyboardType: TextInputType.text,
              obscureText: controller.isHidden.value,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.isHidden.toggle();
                    },
                    icon: Icon(controller.isHidden.isFalse
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                  controller.isLoading(true);

                  Map<String, dynamic> hasil =
                      await authC.login(emailC.text, passC.text);
                  controller.isLoading(false);

                  if (hasil["error"] == true) {
                    Get.snackbar("Error", hasil["message"]);
                  } else {
                    // Pass a success message when navigating to the home page
                    Get.offAllNamed(Routes.home, arguments: {
                      "message": "Login Successful",
                      "type": "success",
                    });
                  }
                } else {
                  Get.snackbar("Error", "Email dan password wajib diisi.");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(controller.isLoading.isFalse ? "LOGIN" : "LOADING..."),
            ),
          )
        ],
      ),
    );
  }
}
