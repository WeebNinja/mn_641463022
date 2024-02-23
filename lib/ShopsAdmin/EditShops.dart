import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/ShopsAdmin/ShowDataShops.dart';

class EditShop extends StatefulWidget {
  final Map<String, dynamic> shopData;

  const EditShop({required this.shopData});

  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  final TextEditingController shopNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    shopNameController.text = widget.shopData['ShopName'].toString();
  }

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
              'แก้ไขข้อมูล',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: shopNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateShopData(shopNameController.text);
                  },
                  child: Text('ยืนยัน'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateShopData(String newShopName) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Shops/Update.php'),
        body: {
          'ShopID': widget.shopData['ShopID'].toString(),
          'ShopName': newShopName,
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
                MaterialPageRoute(builder: (context) => ShowDataShops()),
              );
            });
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text('แก้ไขข้อมูลร้านค้าเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to update shop data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update shop data'),
      ));
    }
  }
}
