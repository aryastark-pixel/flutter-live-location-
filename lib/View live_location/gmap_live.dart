import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Gmap_Live extends StatefulWidget {
  final Position? initialPosition;
  final Stream<Position>? positionStream;

  Gmap_Live({required this.initialPosition, required this.positionStream});

  @override
  State<Gmap_Live> createState() => _Gmap_LiveState();
}

class _Gmap_LiveState extends State<Gmap_Live> {
  GoogleMapController? _mapController;
  Marker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    if (widget.positionStream != null) {
      widget.positionStream!.listen((Position position) {
        _updatePosition(position);
        print("here at the gmap, printing the position");
        print(position);
      });
    }
    if (widget.initialPosition != null) {
      _updatePosition(widget.initialPosition!);
    }
  }

  void _updatePosition(Position position) {
    setState(() {
      _currentLocationMarker = Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Current Location'),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location on Map'),
      ),
      body: widget.initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialPosition!.latitude, widget.initialPosition!.longitude),
          zoom: 29.0,
        ),
        markers: _currentLocationMarker != null ? {_currentLocationMarker!} : {},
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          if (widget.initialPosition != null) {
            _updatePosition(widget.initialPosition!);
          }
        },
      ),
    );
  }
}
