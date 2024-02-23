import 'package:flutter/material.dart';
import 'package:mn_641463022/Login/Login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE4E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 150.0),
              child: SizedBox(
                height: 300.0,
                child: Image.asset(
                  'images/Smart.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'ยินดีต้อนรับสู่ smart tourism',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                    fontFamily: 'ThSarabun',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0, // ปรับความสูงของ Sizebox ตามที่ต้องการ
                ),
                //  Widget อื่น ๆ ที่คุณต้องการเพิ่มใน Column นี้
              ],
            ),
            SizedBox(
//width: double.infinity, // ก ําหนดควํามกว้ํางให้เต็มหน้ําจอ
              child: OutlinedButton(
                onPressed: () {
// เมื่อปุ่มถูกคลิก
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                },
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(300, 50),

                  backgroundColor:
                      Color(0xFF695A5B), // Set the background color
                ),
                child: Text(
                  'เริ่มใช้งาน',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ThSarabun',
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Set the text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
