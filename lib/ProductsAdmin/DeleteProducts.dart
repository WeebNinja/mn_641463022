import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/ProductsAdmin/ShowGroupProduct.dart';

class DeleteProduct extends StatelessWidget {
  final String shopID;
  final String shopName;
  final String productID;
  final String productName;

  const DeleteProduct(
      {required this.shopID,
      required this.shopName,
      required this.productID,
      required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ลบข้อมูล',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'รหัสสินค้า $productID?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'ชื่อสินค้า $productName?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'ชื่อร้าน $shopName?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _deleteProductData(context);
                  },
                  child: Text('ยืนยัน'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Close this page when Cancel button is pressed
                  },
                  child: Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.red, // Set color to red
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProductData(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Products/Delete.php'),
        body: {
          'ShopID': shopID,
          'ProductID': productID,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowGroupProduct(
                    shopId: shopID,
                    shopName: shopName,
                  ),
                ),
              );
            });
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text('ลบข้อมูลสินค้าเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to delete product data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete product data'),
      ));
    }
  }
}
