import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/TrainsAdmin/ShowDataTrains.dart';

class EditTrainsPage extends StatelessWidget {
  final Map<String, dynamic> trainData;

  const EditTrainsPage({required this.trainData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController trainNumberController =
        TextEditingController(text: trainData['TrainNumber'].toString());

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // เปลี่ยนสีพื้นหลังเป็นสีขาว
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'แก้ไขข้อมูล',
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
                  labelText: 'หมายเลขรถราง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateTrainData(context, trainNumberController.text);
                    },
                    child: Text('ยืนยัน'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      primary: Colors.blue, // ตั้งค่าสีปุ่มเป็นสีเขียว
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // กำหนดขอบปุ่มเป็นรูปทรงวงกลม
                      ),
                    ),
                  ),
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
                      primary: Colors.grey, // ตั้งค่าสีปุ่มเป็นสีแดง
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // กำหนดขอบปุ่มเป็นรูปทรงวงกลม
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

  Future<void> _updateTrainData(
      BuildContext context, String newTrainNumber) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Trains/Update.php'),
        body: {
          'ID': trainData['ID'].toString(),
          'TrainNumber': newTrainNumber,
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
                  Text('แก้ไขข้อมูลรถรางเรียบร้อย',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to update train data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update train data'),
      ));
    }
  }
}
