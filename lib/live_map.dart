import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LiveMap extends StatefulWidget {
  const LiveMap({super.key});

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
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
        title: Text('map'),
      ),
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