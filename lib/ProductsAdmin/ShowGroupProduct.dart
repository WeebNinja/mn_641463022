import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/GPSMap/Map.dart';
import 'package:mn_641463022/MainMenu.dart';
import 'package:mn_641463022/ProductsAdmin/DeleteProducts.dart';
import 'package:mn_641463022/ProductsAdmin/EditProducts.dart';
import 'package:mn_641463022/ProductsAdmin/ShowDataProducts.dart';
import 'package:mn_641463022/ProductsAdmin/ShowProducts.dart';
import 'package:mn_641463022/User/Logout.dart';

class ShowGroupProduct extends StatefulWidget {
  final String shopId;
  final String shopName;
  const ShowGroupProduct({required this.shopId, required this.shopName});

  @override
  _ShowGroupProductState createState() => _ShowGroupProductState();
}

class _ShowGroupProductState extends State<ShowGroupProduct> {
  late Future<List<dynamic>> _showData;

  Future<List<dynamic>> _fetchShowData() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:82/apiMN_641463022/Products/GetProductShop.php?shopID=${widget.shopId}'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'ยังไม่มีรายการสินค้า';
    }
  }

  @override
  void initState() {
    super.initState();
    _showData = _fetchShowData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE4E1),
      appBar: AppBar(
        backgroundColor: Color(0xFF695A5B),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowDataProducts(),
              ),
            );
          },
        ),
        title: Text(
          '${widget.shopName}',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: FutureBuilder<List<dynamic>>(
          future: _showData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = snapshot.data![index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      leading: Icon(Icons.shopping_bag_rounded,
                          size: 36, color: Color(0xFF695A5B)),
                      title: Text(
                        '${data['ProductName']}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ThSarabun',
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ราคา : ${data['Price']} บาท',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ThSarabun',
                            ),
                          ),
                          Text(
                            'หน่วย : ${data['Unit']}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ThSarabun',
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.visibility),
                              title: Text('ดูเพิ่มเติม'),
                              onTap: () {
                                Navigator.pop(context); // Close the PopupMenu
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: ShowProducts(
                                          shopName: data['ShopName'].toString(),
                                          productId:
                                              data['ProductID'].toString(),
                                          productName:
                                              data['ProductName'].toString(),
                                          unit: data['Unit'].toString(),
                                          price: double.parse(
                                              data['Price'].toString()),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('แก้ไข'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: EditProduct(
                                          productData: data,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('ลบ'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        child: DeleteProduct(
                                          shopID: data['ShopID'].toString(),
                                          shopName: data['ShopName'].toString(),
                                          productID:
                                              data['ProductID'].toString(),
                                          productName:
                                              data['ProductName'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'แผนที่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_rounded),
            label: 'ออกจากระบบ',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Color(0xFF8B4513),
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainMenu()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GPSTracking()),
            );
          }
          if (index == 2) {
            showLogoutDialog(context);
          }
        },
      ),
    );
  }
}
