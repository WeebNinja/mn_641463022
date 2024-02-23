import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/Login/Login.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void submitForgotPassword() async {
    String phoneNumber = phoneNumberController.text;
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      print("Passwords do not match");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('รหัสผ่านไม่ตรงกัน'),
            icon: Icon(Icons.cancel, color: Colors.red, size: 48),
            content: Text(
              'กรุณากรอกรหัสผ่านให้ตรงกัน',
              textAlign: TextAlign.center, // กำหนดให้ข้อความอยู่ตรงกลาง
            ),
            actions: [
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
          );
        },
      );
      return;
    }

    // URL of the API to be called
    String apiUrl = 'http://localhost:82/apiMN_641463022/Login/ForgotPass.php';

    // Create the request body to send data
    Map<String, dynamic> requestBody = {
      'PhoneNumber': phoneNumber,
      'Email': email,
      'Username': username,
      'Password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        // Action to take when the request is successful
        showSuccessDialog(context);
      } else {
        // Action to take when the request fails
        print('Failed to process forgot password request');
      }
    } catch (error) {
      // Action to take when there is a connection error
      print('Connection error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE4E1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF695A5B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
          },
        ),
        title: Text(
          'ลืมรหัสผ่าน',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์',
                icon: Icon(Icons.phone),
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                icon: Icon(Icons.email),
              ),
            ),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'ชื่อผู้ใช้',
                icon: Icon(Icons.person_outline),
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'รหัสผ่านใหม่',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่านใหม่',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: submitForgotPassword,
              icon: Icon(Icons.save),
              label: Text('บันทึก'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
        });
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 16),
              Text('การกู้คืนรหัสผ่านสำเร็จ'),
            ],
          ),
        );
      },
    );
  }
}
