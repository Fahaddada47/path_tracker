import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //late final GoogleMapController _googleMapController;

  LocationData? myCurrentLocation;
  late StreamSubscription _locationSubscription;

  @override
  void initState() {
    initilalize();
    super.initState();
  }


  void initilalize(){
    Location.instance.changeSettings(
      interval: 3000,
      distanceFilter: 10,
      accuracy: LocationAccuracy.high
    );
  }


  Future<void> getMyLocation() async {
    await Location.instance.requestPermission().then((requestedPermission) {
      print(requestedPermission);
    });
    await Location.instance.hasPermission().then((permissonStatus) {
      print(permissonStatus);
    });
    myCurrentLocation = await Location.instance.getLocation();

    print(myCurrentLocation);
    if (mounted) {
      setState(() {});
    }
  }

  void listenToMyLocation() {
    _locationSubscription =
        Location.instance.onLocationChanged.listen((location) {
      if (location != myCurrentLocation) myCurrentLocation = location;
      print('Listening to location $location');
      if (mounted) {
        setState(() {});
      }
    });
  }

  void stopToLisetenLocation() {
    _locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Screen'),
      ),
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     zoom: 10,
      //     bearing: 30,
      //     tilt: 10,
      //     target: LatLng(23.791508, 90.374946),
      //   ),
      //   myLocationEnabled: true,
      //   myLocationButtonEnabled: true,
      //   zoomGesturesEnabled: true,
      //   trafficEnabled: true,
      //   onTap: (LatLng l) {
      //     print(l);
      //   },
      //   onLongPress: (LatLng l) {
      //     print(l);
      //   },
      //   onMapCreated: (GoogleMapController? controller) {
      //     print('on map created');
      //     _googleMapController = controller!;
      //   },
      //   compassEnabled: true,
      //   mapType: MapType.normal,
      //   markers: <Marker>{
      //     Marker(
      //         markerId: MarkerId('custom-marker'),
      //         position: LatLng(23.791508, 90.374946),
      //         infoWindow: InfoWindow(title: 'Bazar'),
      //         // draggable: true,
      //         onDragStart: (LatLng latLng) {
      //           print(latLng);
      //         },
      //         onDragEnd: (LatLng latLng) {
      //           print(latLng);
      //         }),
      //     Marker(
      //         markerId: MarkerId('custom-marker-2'),
      //         position: LatLng(23.75303003426938, 90.3684839246537),
      //         infoWindow: InfoWindow(title: 'Hospital'),
      //         // draggable: true,
      //         onDragStart: (LatLng latLng) {
      //           print(latLng);
      //         },
      //         onDragEnd: (LatLng latLng) {
      //           print(latLng);
      //         }),
      //   },
      //   polylines: <Polyline>{
      //     Polyline(polylineId: PolylineId('polyline'),points:[
      //       LatLng(23.791508, 90.374946),
      //       LatLng(23.75303003426938, 90.3684839246537)
      //     ])
      //   },
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('GPS LOCATON'),
            Text('${myCurrentLocation?.latitude ?? ''}'
                '${myCurrentLocation?.longitude ?? ''}'),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              getMyLocation();
            },
            child: Icon(Icons.my_location),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              listenToMyLocation();
            },
            child: Icon(Icons.location_on),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              stopToLisetenLocation();
            },
            child: Icon(Icons.stop_circle_rounded),
          ),
        ],
      ),
    );
  }
}
