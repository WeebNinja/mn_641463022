import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/TrainsAdmin/ShowDataTrains.dart';

class DeleteTrainsPage extends StatelessWidget {
  final String trainId;
  final String trainNumber;

  const DeleteTrainsPage({required this.trainId, required this.trainNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ลบข้อมูล',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ThSarabun',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 16.0),
              Text(
                'รหัสรถราง : $trainId',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ThSarabun',
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'หมายเลขรถ : $trainNumber ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ThSarabun',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                          color: Colors.black), // เปลี่ยนสีตัวหนังสือเป็นสีดำ
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _deleteTrainData(context);
                    },
                    child: Text('ยืนยัน'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTrainData(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Trains/Delete.php'),
        body: {
          'ID': trainId,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowDataTrains()),
              );
            });
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text('ลบข้อมูลรถรางเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to delete train data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete train data'),
      ));
    }
  }
}
