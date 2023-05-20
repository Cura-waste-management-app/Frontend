import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/screens/homeListings/home_listings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/debug_print.dart';

class Location extends StatefulWidget {
  const Location({super.key});
  static const routeName = '/location-screen';

  @override
  // ignore: library_private_types_in_public_api
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  var locationMessage = "";

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const ErrorScreen(error: "LOCATION PERMISION NOT GIVEN");
        }));
      }
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    // ignore: avoid_print
    prints(lastPosition);

    setState(() {
      locationMessage = "$position.latitude, $position.longitude";
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ignore: prefer_const_constructors
            Icon(
              Icons.location_on,
              size: 46.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'GET user location',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // ignore: prefer_const_constructors
            Text(locationMessage),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                // ignore: prefer_const_constructors
                onPressed: () {
                  getCurrentLocation();
                  Navigator.pushNamed(context, HomeListings.routeName);
                },
                child: const Text('Get Current location '))
          ],
        ),
      ),
    );
  }
}
