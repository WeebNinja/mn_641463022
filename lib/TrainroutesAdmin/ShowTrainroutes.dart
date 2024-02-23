import 'package:flutter/material.dart';

class ShowTrainRoutes extends StatelessWidget {
  final String sequence;
  final String spotName;
  final String time;

  ShowTrainRoutes({
    required this.sequence,
    required this.spotName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Sequence : $sequence',
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Spot Name : $spotName',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Time : $time',
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
          ),
        ),
      ],
    );
  }
}
