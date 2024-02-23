import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/ShopsAdmin/ShowDataShops.dart';

class DeleteShop extends StatelessWidget {
  final String shopID;
  final String shopName;

  const DeleteShop({required this.shopID, required this.shopName});

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
              'รหัสร้าน $shopID?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'ชื่อร้าน $shopName?',
              style: TextStyle(
                fontSize: 32,
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
                    _deleteShopData(context);
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

  Future<void> _deleteShopData(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Shops/Delete.php'),
        body: {
          'ShopID': shopID,
        },
      );

      if (response.statusCode == 200) {
        // Check response body for the message from API
        if (response.body.contains('Shop deleted successfully')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowDataShops()),
                );
              });
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 16),
                    Text('ลบข้อมูลร้านค้าเรียบร้อย'),
                  ],
                ),
              );
            },
          );
        } else if (response.body.contains('Cannot delete shop')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cancel, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text('ไม่สามารถลบได้ เพราะร้านค้ายังมีสินค้าอยู่'),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowDataShops()),
                          );
                        },
                        child: Text('ตกลง'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          throw Exception('Failed to delete shop data');
        }
      } else {
        throw Exception('Failed to delete shop data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete shop data'),
      ));
    }
  }
}
