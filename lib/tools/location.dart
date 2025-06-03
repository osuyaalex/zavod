import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier{
  var locationData;  // Observable location data
  String? currentAddress;
  Future<void> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('not enabled');
        return;
      }
    }
    print(serviceEnabled.toString());
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (permissionGranted == PermissionStatus.granted) {
      PermissionStatus backgroundPermission = await location.requestPermission();
      if (backgroundPermission == PermissionStatus.deniedForever) {
        print('Background location permission denied');
        return;
      }
    }
    print(permissionGranted);
    try {
      location.enableBackgroundMode(enable: true);
      location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 10,
        distanceFilter: 5,
      );

      location.onLocationChanged.listen((LocationData currentLocation) {
        locationData = currentLocation;
        notifyListeners();
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        currentAddress = '${place.street}, ${place.subLocality}, '
            '${place.locality}, ${place.postalCode}, '
            '${place.country}';
        notifyListeners();
      }
    } catch (e) {
      currentAddress = 'Error getting address';
      notifyListeners();

    }
  }
}