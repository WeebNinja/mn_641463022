import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mn_641463022/TrainroutesAdmin/ShowDataTrainroutes.dart';
import 'package:flutter/services.dart';

class InsertTrainRoute extends StatefulWidget {
  @override
  _InsertTrainRouteState createState() => _InsertTrainRouteState();
}

class _InsertTrainRouteState extends State<InsertTrainRoute> {
  final TextEditingController timeController = TextEditingController();
  String? selectedSpotID;
  String? selectedSpotName;

  List<Map<String, dynamic>> spotData = []; // List to store spot data

  @override
  void initState() {
    super.initState();
    fetchSpotData();
  }

  Future<void> fetchSpotData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:82/apiMN_641463022/Touristspots/Select.php'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          spotData = responseData.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load spot data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
                'เพิ่มข้อมูลเส้นทางเดินรถ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ThSarabun',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedSpotID,
                items: spotData.map<DropdownMenuItem<String>>((spot) {
                  return DropdownMenuItem<String>(
                    value: spot['SpotID'],
                    child: Text(spot['SpotName']),
                  );
                }).toList(),
                onChanged: (String? value) {
                  final selectedSpot =
                      spotData.firstWhere((spot) => spot['SpotID'] == value);
                  setState(() {
                    selectedSpotID = value;
                    selectedSpotName = selectedSpot['SpotName'];
                  });
                },
                decoration: InputDecoration(
                  labelText: 'สถานที่',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'เวลา',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: true,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        final formattedTime = DateFormat.Hm().format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          pickedTime.hour,
                          pickedTime.minute,
                        ));
                        timeController.text = formattedTime;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submitRouteData(context);
                    },
                    child: Text('ยืนยัน'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ยกเลิก'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.red,
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

  Future<void> _submitRouteData(BuildContext context) async {
    final String spotID = selectedSpotID ?? '';
    final String time = timeController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:82/apiMN_641463022/Trainroutes/Insert.php'),
        body: {
          'SpotID': spotID,
          'Time': time,
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
                  Text('เพิ่มข้อมูลเส้นทางเดินรถเรียบร้อย'),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to submit train route data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit train route data'),
      ));
    }
  }
}
