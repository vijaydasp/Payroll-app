import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();
String? status_otp;

Future<void> otpApi(email, otp) async {
  try {
    final response = await dio.post('$baseurl/otp?email=$email&otp=$otp');
    print(response.data);
    int? res = response.statusCode;
    print(res);
    status_otp = response.data['status'] ?? 'failed';
    if (res == 200 && response.data['status'] == 'success') {
      print("Success");
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
