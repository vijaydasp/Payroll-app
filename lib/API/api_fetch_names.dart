import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();

Future<List<Map<String, dynamic>>> getNames() async {
  try {
    final response = await dio.get('$baseurl/fetchnames');
    print(response.data);
    if (response.statusCode == 200) {
      List<dynamic> namedetails = response.data['names'];
      List<Map<String, dynamic>> namelistdata =
          List<Map<String, dynamic>>.from(namedetails);
      return namelistdata;
    } else {
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
