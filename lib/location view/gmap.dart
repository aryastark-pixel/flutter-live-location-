// Markers of 20 people gmap
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class GMap extends StatefulWidget {

  const GMap({super.key});
  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  GoogleMapController? _controller;
  Set<Marker> _markers={};


  @override
  void initState() {
    super.initState();
    _loadLocations();
  }


  void _loadLocations() {
    print('inside reload ');

    List<Map<String, dynamic>> manualLocations = [
      {'name': 'Location 1', 'latitude': 27.341853, 'longitude': 88.590424},
      {'name': 'Location 2', 'latitude': 27.309657, 'longitude': 88.655143},
      {'name': 'Location 3', 'latitude': 27.368154, 'longitude': 88.605291},
      {'name': 'Location 4', 'latitude': 27.291628, 'longitude': 88.382905},
      {'name': 'Location 5', 'latitude': 27.447123, 'longitude': 88.476288},
      {'name': 'Location 6', 'latitude': 27.336165, 'longitude': 88.448136},
      {'name': 'Location 7', 'latitude': 27.295290, 'longitude': 88.892396},
    ];

    List<Map<String, dynamic>> fetchedLocations = [
      {'name': 'Fetched Location 1', 'latitude': 39.7392, 'longitude': -104.9903},
      {'name': 'Fetched Location 2', 'latitude': 41.8781, 'longitude': -87.6298},
      {'name': 'Fetched Location 3', 'latitude': 34.0522, 'longitude': -118.2437},
      {'name': 'Fetched Location 7', 'latitude': 27.057065, 'longitude': 88.277252},//
      {'name': 'Fetched Location 8', 'latitude': 27.139503, 'longitude': 88.317133},//
      {'name': 'Fetched Location 9', 'latitude': 27.074520, 'longitude': 88.533434},//
      {'name': 'Fetched Location 10', 'latitude': 26.954185, 'longitude': 88.776968},//
      {'name': 'Fetched Location 11', 'latitude': 27.129097, 'longitude':88.358800},//

    ];

    List<Map<String, dynamic>> allLocations = []
      ..addAll(manualLocations)
      ..addAll(fetchedLocations);

    allLocations.forEach((location) {
      print('Name: ${location['name']}, Latitude: ${location['latitude']}, Longitude: ${location['longitude']}');
    });

    setState(() {
      _markers = allLocations.map((location) {
        return Marker(
          markerId: MarkerId(location['name']),
          position: LatLng(location['latitude'], location['longitude']),
          infoWindow: InfoWindow(title: location['name']),
        );
      }).toSet();
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Live Location Map'),
      ),
      body: GoogleMap(
          onMapCreated: (controller) {
            _controller = controller;
          },
        initialCameraPosition: CameraPosition(
          target: LatLng(27.3239418, 88.6136607),
            zoom: 9,
        ),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadLocations,
        child: Icon(Icons.refresh),
      ),

    );
  }
}
