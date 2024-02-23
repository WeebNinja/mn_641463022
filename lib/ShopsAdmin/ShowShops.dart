import 'package:flutter/material.dart';

class ShowShops extends StatelessWidget {
  final String shopId;
  final String shopName;

  ShowShops({
    required this.shopId,
    required this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'รหัสร้านค้า : $shopId',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ชื่อร้านค้า: $shopName',
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
