import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zavod_test/tools/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  Set<Marker> markers = {};
  LatLng? selectedLocation;
  Set<Polyline> polylines = {};
  String duration = '';
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _generateRandomMarkers(double baseLat, double baseLng) {
    final Random random = Random();
    const double maxOffset = 0.005; // ~500 meters

    Set<Marker> newMarkers = {};
    for (int i = 0; i < 7; i++) {
      double latOffset = (random.nextDouble() - 0.5) * maxOffset * 2;
      double lngOffset = (random.nextDouble() - 0.5) * maxOffset * 2;

      LatLng randomPosition = LatLng(baseLat + latOffset, baseLng + lngOffset);

      newMarkers.add(
        Marker(
          markerId: MarkerId('random_marker_$i'),
          position: randomPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() {
      markers = newMarkers;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.getLocation();
      await Future.delayed(Duration(seconds: 4));
      final latitude = locationProvider.locationData?.latitude;
      final longitude = locationProvider.locationData?.longitude;
      print('latttttt $latitude');
      print('long $longitude');
      if (latitude != null && longitude != null) {

        _generateRandomMarkers(latitude, longitude);
      }
    });
  }

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<LocationProvider>(
      builder: (context,locationController,child) {
        final currentLatitude = locationController.locationData?.latitude;
        final currentLongitude = locationController.locationData?.longitude;
        print("sooooooo $currentLongitude");
        if(currentLatitude == null){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        print('lacttta $currentLatitude');
        return Scaffold(
          body: GoogleMap(
            key: const ValueKey('map_key'),
            mapType: MapType.normal,
            myLocationEnabled: true,
            polylines: polylines,
            markers: markers,
            onTap: (LatLng position) async {
              await locationController.getAddressFromLatLng(position);
              setState(() {
                selectedLocation = position;
                markers.clear();
                polylines.clear();
                duration = '';
                // markers.add(
                //   Marker(
                //     markerId: MarkerId('current_location'),
                //     position: LatLng(
                //       currentLatitude,
                //       currentLongitude,
                //     ),
                //     icon: BitmapDescriptor.defaultMarkerWithHue(
                //       BitmapDescriptor.hueBlue,
                //     ),
                //   ),
                // );
                markers.add(
                  Marker(
                    markerId: MarkerId('selected_location'),
                    position: position,
                  ),
                );
              });
              // showAddressSheet(
              //     locationController.currentAddress.value??'',
              //     width,
              //     position,
              //     currentLatitude,
              //     currentLongitude
              // );
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLatitude, currentLongitude!),
              zoom: 17.4746,
              bearing: locationController.locationData.heading??0.0,
              //tilt: 59.440717697143555,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )
        );
      }
    );
  }
}
