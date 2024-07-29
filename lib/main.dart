import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/api_services/location_api.dart';
import 'package:gps/geolocator_Services/location_permission_services.dart';
import 'package:gps/View live_location/gmap_live.dart';
import 'package:gps/location view/Mappls_viewLive.dart';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:ui';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  runApp(const MyApp());
}

const notificationChannelId = 'my_foreground';
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

        flutterLocalNotificationsPlugin.show(
          notificationId,
          'Location Update',
          'Location: ${position.latitude}, ${position.longitude}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // Save or process the location data as needed
        String dateTime = DateTime.now().toIso8601String();
        print(dateTime);
        print('Current position: ${position.latitude}, ${position.longitude}');
      }
    }
  });

  // Access geolocation
  // Timer.periodic(const Duration(seconds: 5), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       flutterLocalNotificationsPlugin.show(
  //         notificationId,
  //         'Location Notifiation',
  //         'Awesome ${DateTime.now()}',
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             notificationChannelId,
  //             'MY FOREGROUND SERVICE',
  //             icon: 'ic_bg_service_small',
  //             ongoing: true,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //
  //   // You can save or process the position data as needed
  //   print('Locked Current Position: ${position.latitude}, ${position.longitude}');
  //   //add a post method here;
  //   String dateTime = DateTime.now().toIso8601String();
  //   print(dateTime);
  //   // postLocationData({
  //   //   'latitude': position.latitude,
  //   //   'longitude': position.longitude,
  //   //   'dateTime': dateTime,
  //   // }
  //   // );
  // });
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
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

  @override
  void dispose(){

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
