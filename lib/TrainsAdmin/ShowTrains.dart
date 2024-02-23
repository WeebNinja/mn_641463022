import 'package:flutter/material.dart';

class ShowTrains extends StatelessWidget {
  final String trainId;
  final String trainNumber;

  ShowTrains({
    required this.trainId,
    required this.trainNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ID : $trainId',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'หมายเลขรถ : $trainNumber',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ตกลง'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              primary: Colors.blue, // ตั้งค่าสีปุ่มเป็นสีเขียว
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0), // กำหนดขอบปุ่มเป็นรูปทรงวงกลม
              ),
            ),
          ),
        ),
      ],
    );
  }
}
