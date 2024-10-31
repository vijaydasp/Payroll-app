import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final Dio dio = Dio();
String? message;

Future<void> updateEmployee(Map<String, dynamic> data) async {
  try {
    print(data);
    final response = await dio.post(
      '$baseurl/updateemployee',
      data: data,
    );

    print(response.data);
    int? res = response.statusCode;
    print(res);

    if (res == 200) {
      print("Success");
      if (response.data is Map<String, dynamic>) {
        message = response.data['message'];
        print(message);
      } else {
        print('Unexpected response format');
      }
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
