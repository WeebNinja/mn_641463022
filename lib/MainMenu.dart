import 'package:flutter/material.dart';
import 'package:mn_641463022/GPSMap/Map.dart';
import 'package:mn_641463022/ProductsAdmin/ShowDataProducts.dart';
import 'package:mn_641463022/ShopsAdmin/ShowDataShops.dart';
import 'package:mn_641463022/TourisSportsAdmin/ShowDataTouris.dart';
import 'package:mn_641463022/TrainroutesAdmin/ShowDataTrainroutes.dart';
import 'package:mn_641463022/TrainsAdmin/ShowDataTrains.dart';
import 'package:mn_641463022/User/Logout.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE4E1),
      appBar: AppBar(
        backgroundColor: Color(0xFF695A5B),
        centerTitle: true,
        title: Text(
          'เมนูหลัก',
          style: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'ThSarabun'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.extent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: [
            buildCard(
              context,
              'images/รถราง.png',
              'รถราง',
              ShowDataTrains(),
            ),
            buildCard(
              context,
              'images/สถานที่ท่องเที่ยว.png',
              'สถานที่ท่องเที่ยว',
              ShowDataTouris(),
            ),
            buildCard(
              context,
              'images/เส้นทางเดินรถ.png',
              'เส้นทางเดินรถ',
              ShowDataTrainroutes(),
            ),
            buildCard(
              context,
              'images/ร้านค้า.png',
              'ร้านค้า',
              ShowDataShops(),
            ),
            buildCard(
              context,
              'images/สินค้า.png',
              'สินค้า',
              ShowDataProducts(),
            ),
            buildCard(
              context,
              'images/จุดท่องเที่ยว.png',
              'จุดท่องเที่ยว',
              GPSTracking(),
            ),
          ],
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
        currentIndex: 0, // กำหนด index ให้เป็น 0 คือหน้า home
        selectedItemColor: Color(0xFF8B4513),
        onTap: (int index) {
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

  Card buildCard(
    BuildContext context,
    String imagePath,
    String text,
    Widget screen,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(imagePath),
              width: 100.0,
              height: 100.0,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ThSarabun'),
            ),
          ],
        ),
      ),
    );
  }
}
