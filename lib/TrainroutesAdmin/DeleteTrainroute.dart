import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/TrainroutesAdmin/ShowDataTrainroutes.dart';

class DeleteTrainRoute extends StatelessWidget {
  final String sequence;
  final String spotId;
  final String sportName;
  const DeleteTrainRoute(
      {required this.sequence, required this.spotId, required this.sportName});

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
              'ลำดับรถ : $sequence?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'สถานที่ : $sportName?',
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
                    _deleteRouteData(context);
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
                    backgroundColor: Colors.red, // Set color to red
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteRouteData(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Trainroutes/Delete.php'),
        body: {
          'Sequence': sequence,
          'SpotID': spotId,
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
                MaterialPageRoute(builder: (context) => ShowDataTrainroutes()),
              );
            });
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text('ลบข้อมูลเส้นทางรถเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to delete train route data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete train route data'),
      ));
    }
  }
}
