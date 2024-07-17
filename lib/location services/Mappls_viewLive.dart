//View Live location of an individual on Mappls

import 'package:flutter/material.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
class Mappls_Live extends StatefulWidget {
  const Mappls_Live({super.key});

  @override
  State<Mappls_Live> createState() => _Mappls_LiveState();
}

class _Mappls_LiveState extends State<Mappls_Live> {
  static const String MAP_SDK_KEY = "95b9310649c290966da44b1842757026";
  static const String REST_API_KEY = "95b9310649c290966da44b1842757026";
  static const String ATLAS_CLIENT_ID = "96dHZVzsAutTl7wIo4MBUaBpm1ifBNI67T1q6JX9wtRbHdrADQ79gCbGuqQD3ct7e2VYM2wKMLkj5iRObEgpVA==";
  static const String ATLAS_CLIENT_SECRET = "lrFxI-iSEg_hICi9PFT-FrjEv09wEUWbU072hl1OCyMxzkp2Q3Di5v7cctdhtJ9_4uVjSxOLH04yi6Gkv1whYWkNODDK5HhB";
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(27.3239671, 88.6136967),
    zoom: 19.0,
  );
  late MapmyIndiaMapController controller;
  @override
  void initState() {
    super.initState();
    MapmyIndiaAccountManager.setMapSDKKey(MAP_SDK_KEY);
    MapmyIndiaAccountManager.setRestAPIKey(REST_API_KEY);
    MapmyIndiaAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);
    MapmyIndiaAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Live Location in Mappls',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.2,
      ),
      body: Expanded(
          child: MapmyIndiaMap(

            initialCameraPosition: _kInitialPosition,
            onMapCreated: (map) =>
                {
                controller = map,
              },
            onStyleLoadedCallback: () => {
              addMarker()
            },
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,

          ))

    );
  }

  void addMarker() async {
    Symbol symbol = await controller.addSymbol(SymbolOptions(geometry: LatLng(27.3239671, 88.6136967)));
  }

}
