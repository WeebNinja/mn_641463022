import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/ProductsAdmin/ShowDataProducts.dart';

class InsertProduct extends StatefulWidget {
  @override
  _InsertProductState createState() => _InsertProductState();
}

class _InsertProductState extends State<InsertProduct> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  late Future<List<Map<String, dynamic>>> _shopsData;
  String? _selectedShopId;

  @override
  void initState() {
    super.initState();
    _shopsData = _fetchShopsData();
  }

  Future<List<Map<String, dynamic>>> _fetchShopsData() async {
    final response = await http.get(
      Uri.parse('http://localhost:82/apiMN_641463022/Shops/Select.php'),
    );
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      return responseData.map((shop) => shop as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load shop data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เพิ่มข้อมูล',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _shopsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No shop data found'));
                  } else {
                    List<DropdownMenuItem<String>> dropdownItems =
                        snapshot.data!.map<DropdownMenuItem<String>>((shop) {
                      return DropdownMenuItem<String>(
                        value: shop['ShopID'].toString(),
                        child: Text(shop['ShopName']),
                      );
                    }).toList();

                    return DropdownButtonFormField(
                      value: _selectedShopId,
                      items: dropdownItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedShopId = value as String?;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'ชื่อร้านค้า',
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                },
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
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submitProductData(context);
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
        );
      },
    );
  }

  Future<void> _submitProductData(BuildContext context) async {
    final String productName = productNameController.text;
    final String unit = unitController.text;
    final String price = priceController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Products/Insert.php'),
        body: {
          'ShopID': _selectedShopId!,
          'ProductName': productName,
          'Unit': unit,
          'Price': price,
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
                MaterialPageRoute(builder: (context) => ShowDataProducts()),
                // shopId: _selectedShopId!,
                //     shopName: 'Your Shop Name',
              );
            });
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text('เพิ่มข้อมูลสินค้าเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to submit product data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit product data'),
      ));
    }
  }
}
