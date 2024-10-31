import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:payroll/API/api_loc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Timer? timer;

Future<void> initService() async {
  var service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      initialNotificationTitle: "Location",
      initialNotificationContent: "Sending...",
      foregroundServiceNotificationId: 90,
    ),
    iosConfiguration: IosConfiguration(),
  );
  service.startService();
  FlutterBackgroundService().invoke("stopService");
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on("setAsForeground").listen((event) {
    print("Foreground ===============");
  });

  service.on("setAsBackground").listen((event) {
    print("Background ===============");
  });

  service.on("stopService").listen((event) {
    service.stopSelf();
    timer?.cancel();
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  timer = Timer.periodic(Duration(seconds: 30), (timer) async {
    print("Background is working");
    print("email: $email");
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latloc(email, position.latitude, position.longitude);
  });
}


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Flutter Background Service"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(height: 200),
//               ElevatedButton(
//                 onPressed: () {
//                   FlutterBackgroundService().invoke("stopService");
//                 },
//                 child: const Text("Stop Service"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   FlutterBackgroundService().startService();
//                 },
//                 child: const Text("Start Service"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }