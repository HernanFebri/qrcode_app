import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/app/data/models/product_model.dart';
import '../../../routes/app_pages.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCTS'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProducts(),
          builder: (context, snapProducts) {
            if (snapProducts.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapProducts.data!.docs.isEmpty) {
              return const Center(
                child: Text("No products"),
              );
            }

            List<ProductModel> allProducts = [];
            for (var element in snapProducts.data!.docs) {
              allProducts.add(ProductModel.fromJson(element.data()));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                ProductModel product = allProducts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailProduct);
                    },
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(product.name),
                                Text("Jumlah : ${product.qty}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: QrImageView(
                              data: product.code,
                              size: 200.0,
                              version: QrVersions.auto,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
