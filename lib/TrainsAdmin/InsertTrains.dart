import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/TrainsAdmin/ShowDataTrains.dart';

class InsertTrainsPage extends StatelessWidget {
  final TextEditingController trainNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เพิ่มข้อมูลรถราง',
                style: TextStyle(
                  fontFamily: 'ThSarabun',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: trainNumberController,
                decoration: InputDecoration(
                  labelText: 'หมายเลขรถ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submitTrainData(context);
                    },
                    child: Text('ยืนยัน'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // ปิดหน้านี้เมื่อกดปุ่มยกเลิก
                    },
                    child: Text('ยกเลิก'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.red, // ตั้งค่าสีแดง
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitTrainData(BuildContext context) async {
    final String trainNumber = trainNumberController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Trains/Insert.php'),
        body: {
          'TrainNumber': trainNumber,
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
                  Text('เพิ่มข้อมูลรถรางเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        // Handle other status codes
        throw Exception('Failed to submit train data');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit train data'),
      ));
    }
  }
}
