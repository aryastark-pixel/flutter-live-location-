import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as geolocator_accuracy;
import 'location services/Mappls_viewLive.dart';
import 'location services/gmap.dart';
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
  String locationMessage = 'Current Location of the User';

  String lat = 'Unknown';
  String long = 'Unknown';

  Future<void> getlocation() async {
    await geolocator.Geolocator.checkPermission();
    await geolocator.Geolocator.requestPermission();
    geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator_accuracy.LocationAccuracy.high,
    );
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      locationMessage = 'Latitude: $lat, Longitude: $long';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Latitude: $lat'),
            Text('Longitude: $long'),
            Text(locationMessage),
            SizedBox(height: 13),
            ElevatedButton(
             onPressed:(){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) =>  GMap(),),
               );
             } ,//GoogleMap(),
              //onPressed: _openGoogleMaps,
            child: const Text('Open Location in Gmap'),
            ),
            SizedBox(height: 13),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Mappls_Live(),),
                );
              },
              child: const Text('Open Location in Mappls'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getlocation();
        },
        child: const Text('Get Location'),
      ),
    );
  }
}
