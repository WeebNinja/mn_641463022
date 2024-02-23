import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mn_641463022/MainMenu.dart';
import 'package:mn_641463022/User/Logout.dart';

class GPSTracking extends StatefulWidget {
  @override
  _GPSTrackingState createState() => _GPSTrackingState();
}

class _GPSTrackingState extends State<GPSTracking> {
  GoogleMapController? mapController;
  List<Marker> markers = [];
  LatLngBounds? bounds;
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:82/apiMN_641463022/TouristSpots/Select.php'));
      if (response.statusCode == 200) {
        List<dynamic> locations = json.decode(response.body);
        List<LatLng> points = [];
        for (var location in locations) {
          points.add(LatLng(double.parse(location['Latitude'].trim()),
              double.parse(location['Longitude'].trim())));
        }
        setState(() {
          markers = locations.map((location) {
            return Marker(
              markerId: MarkerId(location['SpotID'].toString()),
              position: LatLng(double.parse(location['Latitude'].trim()),
                  double.parse(location['Longitude'].trim())),
              infoWindow: InfoWindow(
                title: location['SpotName'],
              ),
            );
          }).toList();

          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: points,
            color: Colors.blue, // สีของเส้น Polyline
            width: 3, // ความกว้างของเส้น Polyline
          ));

          bounds = _calculateBounds(markers);
        });
      } else {
        throw Exception('การโหลดตำแหน่งผิดพลาด');
      }
    } catch (error) {
      print('Error fetching locations: $error');
    }
  }

  LatLngBounds _calculateBounds(List<Marker> markers) {
    double minLat = markers[0].position.latitude;
    double minLng = markers[0].position.longitude;
    double maxLat = markers[0].position.latitude;
    double maxLng = markers[0].position.longitude;

    for (Marker marker in markers) {
      if (marker.position.latitude < minLat) {
        minLat = marker.position.latitude;
      }
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.latitude > maxLat) {
        maxLat = marker.position.latitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE4E1),
      appBar: AppBar(
        backgroundColor: Color(0xFF695A5B),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainMenu(),
            ));
          },
        ),
        title: Text(
          'จุดท่องเที่ยว',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ThSarabun',
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(13.7563, 100.5018),
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
            if (bounds != null) {
              controller
                  .animateCamera(CameraUpdate.newLatLngBounds(bounds!, 50));
            }
          });
        },
        markers: Set<Marker>.of(markers),
        polylines: polylines,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'แผนที่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_rounded),
            label: 'ออกจากระบบ',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Color(0xFF8B4513),
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainMenu()),
            );
          }
          if (index == 2) {
            showLogoutDialog(context);
          }
        },
      ),
    );
  }
}
