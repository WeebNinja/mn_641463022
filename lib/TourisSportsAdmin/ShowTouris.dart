import 'package:flutter/material.dart';

class ShowTouris extends StatelessWidget {
  final String spotId;
  final String spotName;
  final double latitude;
  final double longitude;

  ShowTouris(
      {required this.spotId,
      required this.spotName,
      required this.latitude,
      required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ID : $spotId',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ชื่อสถานที่ : $spotName',
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ละติจูด : $latitude',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ลองติจูด : $longitude',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20), // Add some space between the text and the button
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('ตกลง'),
          ),
        ),
      ],
    );
  }
}
