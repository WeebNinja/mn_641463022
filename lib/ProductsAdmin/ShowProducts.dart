import 'package:flutter/material.dart';

class ShowProducts extends StatelessWidget {
  final String shopName;
  final String productId;
  final String productName;
  final String unit;
  final double price;

  ShowProducts({
    required this.shopName,
    required this.productId,
    required this.productName,
    required this.unit,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ชื่อร้านค้า : $shopName',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'รหัสสินค้า : $productId',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ชื่อสินค้า : $productName',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'หน่วย : $unit',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ราคา : $price',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ตกลง'),
          ),
        ),
      ],
    );
  }
}
