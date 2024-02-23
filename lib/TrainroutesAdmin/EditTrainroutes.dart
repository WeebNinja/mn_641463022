import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:mn_641463022/TrainroutesAdmin/ShowDataTrainroutes.dart'; // นำเข้าไลบรารี json

class EditTrainRoute extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final List<Map<String, dynamic>> spotData;

  const EditTrainRoute({required this.routeData, required this.spotData});

  @override
  _EditTrainRouteState createState() => _EditTrainRouteState();
}

class _EditTrainRouteState extends State<EditTrainRoute> {
  final TextEditingController spotIDController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    spotIDController.text = widget.routeData['SpotID'].toString();
    timeController.text = DateFormat.Hm().format(
      DateFormat('HH:mm:ss').parse(widget.routeData['Time']),
    );
  }

  Future<List<Map<String, dynamic>>> fetchSpotData() async {
    final response = await http.get(
      Uri.parse('http://localhost:82/apiMN_641463022/Touristspots/Select.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load spot data');
    }
  }

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
              'แก้ไขข้อมูล',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'ThSarabun',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchSpotData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading spot data: ${snapshot.error}');
                } else {
                  return DropdownButtonFormField<String>(
                    value: widget.routeData['SpotName'].toString(),
                    items: snapshot.data!.map<DropdownMenuItem<String>>((spot) {
                      return DropdownMenuItem<String>(
                        value: spot['SpotName'].toString(),
                        child: Text(spot['SpotName'].toString()),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      final selectedSpot = snapshot.data!.firstWhere(
                          (spot) => spot['SpotName'] == value,
                          orElse: () => {});
                      spotIDController.text = selectedSpot['SpotID'].toString();
                    },
                    decoration: InputDecoration(
                      labelText: 'Spot Name',
                      border: OutlineInputBorder(),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateRouteData(
                      context,
                      spotIDController.text,
                      timeController.text,
                    );
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final formattedTime = DateFormat.Hm().format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      ));
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  Future<void> _updateRouteData(
    BuildContext context,
    String newSpotID,
    String newTime,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Trainroutes/Update.php'),
        body: {
          'Sequence': widget.routeData['Sequence'].toString(),
          'SpotID': newSpotID,
          'Time': newTime,
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
                  Text('แก้ไขข้อมูลเส้นทางเดินรถเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to update train route data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update train route data'),
      ));
    }
  }
}
