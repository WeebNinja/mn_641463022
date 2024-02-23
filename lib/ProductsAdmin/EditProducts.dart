import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463022/ProductsAdmin/ShowGroupProduct.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> productData;

  const EditProduct({required this.productData});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.productData['ProductName'].toString();
    unitController.text = widget.productData['Unit'].toString();
    priceController.text = widget.productData['Price'].toString();
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
                fontFamily: 'ThSarabun',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อสินค้า',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: unitController,
              decoration: InputDecoration(
                labelText: 'หน่วย',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'ราคา',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateProductData(
                      productNameController.text,
                      unitController.text,
                      double.parse(priceController.text),
                    );
                  },
                  child: Text('ยืนยัน'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // ปิดหน้านี้เมื่อกดปุ่มยกเลิก
                  },
                  child: Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.red, // ตั้งค่าสีแดง
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProductData(
      String newProductName, String newUnit, double newPrice) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Products/Update.php'),
        body: {
          'ShopID': widget.productData['ShopID'].toString(),
          'ProductID': widget.productData['ProductID'].toString(),
          'ProductName': newProductName,
          'Unit': newUnit,
          'Price': newPrice.toString(),
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
                    shopId: widget.productData['ShopID'].toString(),
                    shopName: widget.productData['ShopName'].toString(),
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
                  Text('แก้ไขข้อมูลสินค้าเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to update product data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update product data'),
      ));
    }
  }
}
