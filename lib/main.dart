import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/api_services/location_api.dart';
import 'package:gps/geolocator_Services/location_permission_services.dart';
import 'package:gps/View live_location/gmap_live.dart';
import 'package:gps/location view/Mappls_viewLive.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GPS Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocationService _locationService = LocationService();
  Stream<Position>? _positionStream;
  Position? _currentPosition;
  String lat = '';
  String long = '';
  String locationMessage = '';
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    bool hasPermission = await _locationService.checkAndRequestPermission();
    if (hasPermission) {
      setState(() {
        _hasPermission = true;
        _positionStream = _locationService.getPositionStream();
      });
      _getCurrentLocation();
    } else {
      setState(() {
        _hasPermission = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        lat = position.latitude.toString();
        long = position.longitude.toString();
        locationMessage = 'Latitude: $lat, Longitude: $long';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _hasPermission
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //if (_currentPosition != null) Text(locationMessage),
            SizedBox(height: 20),
            StreamBuilder<Position>(
              stream: _positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  Position position = snapshot.data!;
                  lat = position.latitude.toString();
                  long = position.longitude.toString();
                  String dateTime = DateTime.now().toIso8601String();
                  print(dateTime);
                  postLocationData({
                    'latitude': position.latitude,
                    'longitude': position.longitude,
                    'dateTime': dateTime,
                   }
                  );

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('Live Location'),
                      ),
                      Center(
                        child: Text('Latitude: $lat, Longitude: $long'),
                      ),
                    ],
                  );
                } else {
                  return Text('No position data');
                }
              },
            ),
            SizedBox(height: 13),
            ElevatedButton(
              onPressed: _currentPosition != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Gmap_Live(
                      initialPosition: _currentPosition!,
                      positionStream: _positionStream!,
                    ),
                  ),
                );
              }
                  : null,
              child: const Text('Open Live Location in Gmap'),
            ),
            SizedBox(height: 13),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mappls_Live(),
                  ),
                );
              },
              child: const Text('Open Location in Mappls'),
            ),
          ],
        )
            : Text('Permission to access location is required.'),
      ),
    );
  }
}
