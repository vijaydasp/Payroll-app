import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payroll/API/api_loc.dart';
import 'package:payroll/API/api_logout.dart';
import 'package:payroll/web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Timer? timer;
String? emailcheck;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.email});
  final String email;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  File? _profileImage;
  String? _currentLocation;
  LatLng? _currentLatLng;
  GoogleMapController? _mapController;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      _currentLocation =
          "${place.locality},${place.street},${place.thoroughfare}, ${place.postalCode}, ${place.country}";
      _currentLatLng = LatLng(position.latitude, position.longitude);
      print(_currentLatLng!.latitude);
      print(_currentLatLng!.longitude);
      mapurl =
          'https://www.google.com/maps?q=${_currentLatLng!.latitude},${_currentLatLng!.longitude}';
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLatLng!),
      );
    }
  }

  void _submit() async {
    emailcheck = widget.email;
    print(emailcheck);
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latloc(widget.email, position.latitude, position.longitude);
    await FlutterBackgroundService().startService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', widget.email);
  }

  void _logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    FlutterBackgroundService().invoke("stopService");
    timer?.cancel();
    print("Logout button pressed");
    logoutApi(widget.email);
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                _logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        print("didpop: $didPop");
        if (!didPop) {
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Dashboard'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileImage == null
                      ? CircleAvatar(
                          radius: 100,
                          child: Icon(Icons.person, size: 50),
                        )
                      : CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(_profileImage!),
                        ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              onPressed: _pickImage,
              child: Text("Upload Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              onPressed: _getCurrentLocation,
              child: Text("Track GPS Location"),
            ),
            SizedBox(height: 20),
            _currentLocation == null
                ? Text("No location data",
                    style: TextStyle(fontSize: 16, color: Colors.black54))
                : Text("Location: $_currentLocation",
                    style: TextStyle(fontSize: 16, color: Colors.black87)),

            // if (_currentLatLng != null)
            //   Container(
            //     height: 700,
            //     width: double.infinity,
            //     child: WebView(),
            //   ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              onPressed: _submit,
              child: Text("Submit"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              onPressed: _logout,
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
