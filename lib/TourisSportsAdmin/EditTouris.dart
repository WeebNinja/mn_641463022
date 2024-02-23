import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463022/TourisSportsAdmin/ShowDataTouris.dart';

class EditToiris extends StatelessWidget {
  final Map<String, dynamic> spotData;

  const EditToiris({required this.spotData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController spotNameController =
        TextEditingController(text: spotData['SpotName'].toString());
    final TextEditingController latitudeController =
        TextEditingController(text: spotData['Latitude'].toString());
    final TextEditingController longitudeController =
        TextEditingController(text: spotData['Longitude'].toString());

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'แก้ไขข้อมูล',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: spotNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อสถานที่',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: latitudeController,
              decoration: InputDecoration(
                labelText: 'ละติจูด',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: longitudeController,
              decoration: InputDecoration(
                labelText: 'ลองจิจูด',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateSpotData(
                      context,
                      spotNameController.text,
                      latitudeController.text,
                      longitudeController.text,
                    );
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

  Future<void> _updateSpotData(
    BuildContext context,
    String newSpotName,
    String newLatitude,
    String newLongitude,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:82/apiMN_641463022/TouristSpots/Update.php'),
        body: {
          'SpotID': spotData['SpotID'].toString(),
          'SpotName': newSpotName,
          'Latitude': newLatitude,
          'Longitude': newLongitude,
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
                MaterialPageRoute(builder: (context) => ShowDataTouris()),
              );
            });
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text('แก้ไขข้อมูลสถานที่ท่องเที่ยวเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to update tourist spot data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update tourist spot data'),
      ));
    }
  }
}
