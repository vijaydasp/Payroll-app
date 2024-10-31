import 'package:dio/dio.dart';

final String baseurl = "http://192.168.58.235:5000";
final dio = Dio();
int? lid;
String? usertype;
String? status;

Future<void> emailPass(email, password) async {
  try {
    final response =
        await dio.post('$baseurl/login?email=$email&password=$password');
    print(response.data);
    int? res = response.statusCode;
    print(res);
    status = response.data[0]['status'] ?? 'failed';
    if (res == 200 && response.data[0]['status'] == 'success') {
      print("Success");
      usertype = response.data[0]['usertype'];
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
