import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Services/ApiServices/ApiService.dart';
import 'BookDetails_Page.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  BarcodePageState createState() => BarcodePageState();
}

class BarcodePageState extends State<BarcodePage> {
  final itemsCubit = ItemsCubit();
  String barcode = '';
  String bookTitle = '';
  String bookDescription = '';
  String bookImage = '';
  String scanBarcode = 'Unknown';

  Future<void> navigateToBookDetailsPage(String isbn) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(isbn: isbn),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scanBarcode();
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on Exception {
      barcodeScanRes = 'Failed to get barcode';
    }

    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
    });

    if (barcodeScanRes != '-1') {
      // navigate to BookDetailsPage and fetch book data
      await navigateToBookDetailsPage(barcodeScanRes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Spacer(),
          Image.network(
              'https://media.tenor.com/8E3SIU76kHgAAAAC/barcode-scan.gif'),
          ElevatedButton(
            onPressed: _scanBarcode,
            child: const Text('Start Barcode scan'),
          ),
          const Spacer()
        ],
      )),
    );
  }
}
