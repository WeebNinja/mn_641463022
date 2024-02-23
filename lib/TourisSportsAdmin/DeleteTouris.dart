import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/TourisSportsAdmin/ShowDataTouris.dart';

class DeleteTouris extends StatelessWidget {
  final String spotId;
  final String spotName;
  const DeleteTouris({required this.spotId, required this.spotName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 16.0),
            Text(
              'ID : $spotId?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'สถานที่ :  $spotName?',
              style: TextStyle(
                fontSize: 26,
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
                    _deleteSpotData(context);
                  },
                  child: Text('ยืนยัน'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Close this page when Cancel button is pressed
                  },
                  child: Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    primary: Colors.red, // Set color to red
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteSpotData(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:82/apiMN_641463022/TouristSpots/Delete.php'),
        body: {
          'SpotID': spotId,
        },
      );

      if (response.statusCode == 200) {
        if (response.body.contains('Spot deleted successfully')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowDataTouris()),
                );
              });
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 16),
                    Text('ลบข้อมูลสถานที่เรียบร้อย'),
                  ],
                ),
              );
            },
          );
        } else if (response.body.contains(
            'Cannot delete spot. There are train routes referencing it.')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cancel, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text('ไม่สามารถลบได้ เพราะ สถานที่ยังมีรอบอยู่'),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowDataTouris()),
                          );
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
      } else {
        throw Exception('Failed to delete tourist spot data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete tourist spot data'),
      ));
    }
  }
}
