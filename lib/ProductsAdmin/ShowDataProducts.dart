import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/GPSMap/Map.dart';
import 'package:mn_641463022/MainMenu.dart';
import 'package:mn_641463022/ProductsAdmin/InsertProducts.dart';
import 'package:mn_641463022/ProductsAdmin/ShowGroupProduct.dart';
import 'package:mn_641463022/User/Logout.dart';

class ShowDataProducts extends StatefulWidget {
  @override
  _ShowDataProductsState createState() => _ShowDataProductsState();
}

class _ShowDataProductsState extends State<ShowDataProducts> {
  late Future<List<Map<String, dynamic>>> _showData;

  Future<List<Map<String, dynamic>>> _fetchShowData() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:82/apiMN_641463022/Products/SelectProduct.php'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw 'ยังไม่มีรายการร้านค้า';
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
          icon: Icon(Icons.home_outlined),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainMenu(),
              ),
            );
          },
        ),
        title: Text(
          'ข้อมูลสินค้า',
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      leading: Icon(
                        Icons.store,
                        size: 36,
                        color: Color(0xFF695A5B),
                      ),
                      title: Text(
                        '${data['ShopName'].toString()}',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ThSarabun'),
                      ),
                      subtitle: Text(
                        'มีสินค้าทั้งหมด: ${data['ProductCount'].toString()} รายการ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ThSarabun'),
                      ),
                      trailing: Icon(Icons.arrow_forward), // Add icon here
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowGroupProduct(
                              shopId: data['ShopID'].toString(),
                              shopName: data['ShopName'].toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(16.0),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: InsertProduct(),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
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
