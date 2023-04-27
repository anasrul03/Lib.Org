import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import '../Services/ApiService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({super.key});

  @override
  BookDetailsState createState() => BookDetailsState();
}

class BookDetailsState extends State<BookDetailsPage> {
  final itemsCubit = ItemsCubit();
  String barcode = '';
  String bookTitle = '';
  String bookDescription = '';
  String bookImage = '';
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    String isbn = barcode.isNotEmpty ? barcode : '9781974709939';

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await itemsCubit.fetchBookData(isbn, itemsCubit);
    });
  }

  Future<void> scanBarcodeNormal() async {
    print("Scan Barcode Normal running");
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } catch (e) {
      barcodeScanRes = 'Invalid function!';
    }

    if (!mounted) return;

    setState(() {
      barcode = barcodeScanRes;
      String isbn = barcode.isNotEmpty ? barcode : '9781974709939';
      itemsCubit.fetchBookData(isbn, itemsCubit).then((_) {
        setState(() {});
      });
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    String isbn = barcode.isNotEmpty ? barcode : '9781974709939';
    print('title is $bookTitle');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Column(
                    children: [
                      Image.network(
                        itemsCubit.state.isNotEmpty
                            ? itemsCubit
                                .state[0].volumeInfo.imageLinks.smallThumbnail
                            : 'https://via.placeholder.com/100',
                        height: 200,
                      ),
                      const SizedBox(height: 6),
                      Text('ISBN: $isbn'),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemsCubit.state.isNotEmpty
                              ? itemsCubit.state[0].volumeInfo.title
                              : '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        RatingBarIndicator(
                          rating: itemsCubit.state.isNotEmpty
                              ? itemsCubit.state[0].volumeInfo.averageRating
                                  .toDouble()
                              : 0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          unratedColor: Colors.grey[300],
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Author: ${itemsCubit.state.isNotEmpty ? (itemsCubit.state[0].volumeInfo.authors.join(', ')) : ''}',
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Categories: ${itemsCubit.state.isNotEmpty ? (itemsCubit.state[0].volumeInfo.categories.join(', ')) : ''}',
                        ),
                        const SizedBox(height: 20),
                        Text(
                            'Book Publisher: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.publisher : ''}'),
                        const SizedBox(height: 20),
                        Text(
                            'Date of Publish: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.publishedDate : ''}'),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                  'Book Description: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.description : ''}'),
              const SizedBox(height: 20),
              Text(
                  'Book Language: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.language : ''}'),
              const SizedBox(height: 20),
              Text(
                  'Number of Pages: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.pageCount : ''}'),
              const SizedBox(height: 20),
              Text(
                  'Maturity Rating: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.maturityRating : ''}'),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    onPressed: () => scanBarcodeNormal(),
                    child: const Text('Start barcode scan')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
