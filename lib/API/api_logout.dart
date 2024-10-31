import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();

Future<void> logoutApi(email) async {
  try {
    final response = await dio.post('$baseurl/logout?email=$email');
    print(response.data);
    int? res = response.statusCode;
    print(res);
    if (res == 200) {
      print("Success");
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
