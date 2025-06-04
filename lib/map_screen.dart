import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zavod_test/tools/location.dart';
import 'package:http/http.dart' as http;

import 'env/env.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({super.key,});

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

  void _generateRandomMarkers(double baseLat, double baseLng, LocationProvider locationProvider) {
    final Random random = Random();
    const double maxOffset = 0.005; // ~500 meters
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

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
          onTap: () async {
            // Get the address
            await locationProvider.getAddressFromLatLng(randomPosition);
            final address = locationProvider.currentAddress ?? 'No address found';

            // Show bottom sheet
            final screenWidth = MediaQuery.of(context).size.width;
            showAddressSheet(
              address,
              screenWidth,
              randomPosition,
              baseLat,
              baseLng,
              locationProvider
            );
          },
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
      await Future.delayed(Duration(seconds: 6));
      final latitude = locationProvider.locationData?.latitude;
      final longitude = locationProvider.locationData?.longitude;
      print('latttttt $latitude');
      print('long $longitude');
      if (latitude != null && longitude != null) {

        _generateRandomMarkers(latitude, longitude, locationProvider);
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
  showAddressSheet(String address,double width,LatLng tappedPoint,double currentLat, double currentLng, LocationProvider locationProvider){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
              dragHandleColor: Colors.grey.shade200,
              backgroundColor: Colors.white,
              animationController: AnimationController(
                  vsync: Navigator.of(context)),
              enableDrag: true,
              onClosing: (){},
              builder: (context){
                return Builder(
                    builder: (context){
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade200
                              ),
                              child: Text(
                                address,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    getDirections(
                                        currentLat,
                                        currentLng,
                                        tappedPoint,
                                        address,
                                      locationProvider
                                    );

                                  },
                                  child: Text('Track'),
                                ),

                              ],
                            )
                          ],
                        ),
                      );
                    }
                );
              }
          );
        }
    );
  }

  Future<void> getDirections(double latitude, double longitude, LatLng tappedPoint, String address, LocationProvider locationProvider) async {
    final origin = '$latitude,$longitude';
    final destination = '${tappedPoint.latitude},${tappedPoint.longitude}';

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
            'origin=$origin'
            '&destination=$destination'
            '&waypoints=$address'
            '&mode=driving'
            '&key=${Env.GOOGLE_API_KEY}'
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      print(data);
      if (data['status'] == 'OK') {
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decodedPolylinePoints =
        polylinePoints.decodePolyline(data['routes'][0]['overview_polyline']['points']);
        List<LatLng> polylineCoordinates = decodedPolylinePoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        print(polylineCoordinates);
        setState(() {
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              color: Colors.blue,
              points: polylineCoordinates,
              width: 5,
            ),
          );
          duration = data['routes'][0]['legs'][0]['duration']['text'];
          var distance = data['routes'][0]['legs'][0]['distance']['text'];
          print('duration: $duration');
          locationProvider.getTappedLocations(latitude, longitude, tappedPoint, address, duration,distance);
        });
      }
    } catch (e) {
      print('Error getting directions: $e');
    }
  }
}
