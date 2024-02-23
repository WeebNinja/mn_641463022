import 'package:flutter/material.dart';
import 'package:mn_641463022/Login/Login.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.question_mark_sharp, color: Colors.red, size: 48),
        title: Text('ต้องการออกจากระบบหรือไม่?'),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false, // Clear the stack
                  );
                },
                child: Text('ตกลง'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ยกเลิก'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
