import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();
String? message;

Future<void> regPost(Map<String, dynamic> data, String imgPath) async {
  try {
    // Create FormData object
    FormData formData = FormData.fromMap({
      ...data,
      'img': await MultipartFile.fromFile(imgPath,
          filename: imgPath.split('/').last),
    });

    final response =
        await dio.post('${baseurl}/register', data: formData);

    print(response.data);
    int? res = response.statusCode;
    print(res);

    if (res == 200) {
      print("Success");
      message = response.data['message'];
      print(message);
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
