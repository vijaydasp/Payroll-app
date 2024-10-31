import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();
String? status_loc;

Future<void> latloc(email, lat, lng) async {
  try {
    final response =
        await dio.post('$baseurl/latloc?email=$email&lat=$lat&lng=$lng');

    print(response.data);
    int? res = response.statusCode;
    print(res);
    status_loc = response.data['status'] ?? 'failed';
    if (res == 200 && response.data['status'] == 'success') {
      print("Success");
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
