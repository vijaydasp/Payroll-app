import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();

Future<List<Map<String, dynamic>>> getLocation(email) async {
  try {
    final response = await dio.get('$baseurl/fetchlocation?email=$email');
    print(response.data);
    if (response.statusCode == 200) {
      List<dynamic> locdetails = response.data['locations'];
      List<Map<String, dynamic>> listdata =
          List<Map<String, dynamic>>.from(locdetails);
      return listdata;
    } else {
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
