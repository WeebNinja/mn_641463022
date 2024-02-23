import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/Login/ForgotPass.dart';
import 'package:mn_641463022/Login/Register.dart';
import 'package:mn_641463022/MainMenu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int loginAttempts = 0; // เพิ่มตัวแปรเก็บจำนวนครั้งที่ล็อกอินผิดพลาด

  void SubmitLogin(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    String apiUrl = 'http://localhost:82/apiMN_641463022/Login/Login.php';

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Login Successfully');
        showSuccessDialog(context);
      } else {
        print('Login Error');
        showLoginErrorDialog(context);
      }
    } catch (error) {
      print('Connection error: $error');
      showNotConnectDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE4E1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF695A5B),
        title: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/Smart.png'),
                width: 250.0,
                height: 250.0,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้ใช้งาน',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  SubmitLogin(context);
                },
                child: Text('เข้าสู่ระบบ'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordForm(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline),
                    SizedBox(width: 8),
                    Text('ลืมรหัสผ่าน?'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RegisterUserForm(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add),
                    SizedBox(width: 8),
                    Text('สร้างบัญชีผู้ใช้'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เกิดข้อผิดพลาดในการเชื่อมต่อ'),
          content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('กลับ'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainMenu(),
            ),
          );
        });
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 16),
              Text('เข้าสู่ระบบสำเร็จ'),
            ],
          ),
        );
      },
    );
  }

  void showLoginErrorDialog(BuildContext context) {
    loginAttempts++; // เพิ่มจำนวนครั้งที่ล็อกอินผิดพลาด

    // ถ้า loginAttempts เกิน 3 ครั้ง ให้แสดง Dialog ถามว่าต้องการลืมรหัสผ่านหรือไม่
    if (loginAttempts > 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Icon(Icons.admin_panel_settings_sharp,
                color: Colors.green, size: 48),
            title: Text('คุณใส่รหัสผ่านผิดเยอะเกินไป'),
            content: Text(
              'คุณต้องการกู้รหัสผ่านหรือไม่',
              textAlign: TextAlign.center, // กำหนดให้ข้อความอยู่ตรงกลาง
            ),
            actions: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordForm(),
                        ),
                      );
                    },
                    child: Text('ใช่'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ไม่'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('เกิดข้อผิดพลาด'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ตกลง'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
