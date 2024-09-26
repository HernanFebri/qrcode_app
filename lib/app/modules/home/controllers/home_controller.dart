import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart'; // Ganti dengan open_file_plus
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeController extends GetxController {
  void downloadCatalog() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Text(
            "Test pdf",
            style: const pw.TextStyle(fontSize: 50),
          ),
        ),
      ),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocument.pdf');

    // memasukan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    // open pdf menggunakan open_file_plus
    final result = await OpenFile.open(file.path);
    print("Result: ${result.message}");
  }
}
